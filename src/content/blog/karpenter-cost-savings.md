---
title: "How we cut $50k/year off our AWS bill with Karpenter"
description: "Moving from static node groups to Karpenter's dynamic provisioning, and the gotchas we hit along the way."
pubDate: 2025-03-10
tags: ["kubernetes", "aws", "finops", "karpenter"]
---

One of the highest-leverage changes we made to our EKS platform was replacing static, autoscaling-group-based
node pools with [Karpenter](https://karpenter.sh/). The result: roughly **$50k/year** in compute savings, faster
pod scheduling, and a lot less time spent hand-tuning instance types.

## The problem with static node groups

Before Karpenter, our clusters ran on a handful of pre-defined managed node groups, each pinned to specific
instance types and sized around worst-case peak load. That meant:

- Capacity sat idle outside of peak hours.
- Scaling out was slow — the cluster autoscaler had to wait on ASG scaling activities.
- Picking the "right" instance type for a mixed workload was a constant balancing act.

## What changed with Karpenter

Karpenter provisions right-sized nodes on demand, directly from EC2, based on the actual pending pods —
no pre-defined node groups required. A few practical notes from the migration:

- **Start with `Consolidation` enabled** so Karpenter proactively bin-packs and terminates underutilized nodes.
- **Use `NodePool` limits** to guard against runaway spend — one misbehaving deployment can otherwise scale a
  lot of expensive instances very quickly.
- **Mix Spot and On-Demand** through the `NodePool` requirements, but keep critical system workloads
  (ingress controllers, DNS) on On-Demand via taints/tolerations.
- **Watch for pod disruption budgets.** Consolidation will happily evict pods to bin-pack more efficiently —
  make sure your PDBs reflect what you can actually tolerate.

## The outcome

Within a quarter of rolling this out cluster-wide, our EC2 compute spend for the platform dropped noticeably,
node startup times improved (no more waiting on ASG lifecycle hooks), and the team spent far less time on
capacity planning. The biggest lesson: cost savings from autoscaling come from being able to *scale down*
fast and safely, not just scale up.
