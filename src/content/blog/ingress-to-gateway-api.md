---
title: "Migrating from Ingress NGINX to the Gateway API"
description: "Why we moved away from Kubernetes Ingress, what kgateway gave us, and how we did it without downtime."
pubDate: 2025-06-18
tags: ["kubernetes", "gateway-api", "networking"]
---

Kubernetes Ingress has served the ecosystem well, but it was never designed for the traffic-management
complexity that modern platforms need — think traffic splitting, protocol-level routing, and multi-team
ownership of a single load balancer. The [Gateway API](https://gateway-api.sigs.k8s.io/) fixes a lot of that,
and it's where the ecosystem is heading.

## Why we moved

- **Role separation.** Gateway API cleanly separates infrastructure concerns (`Gateway`) from routing rules
  (`HTTPRoute`), which maps much better onto how a platform team and application teams actually collaborate.
- **Expressiveness.** Native support for traffic splitting, header-based routing, and cross-namespace
  references — all things we previously bolted on with NGINX annotations.
- **Vendor neutrality.** The API is portable across implementations, so we're no longer locked into
  controller-specific annotation syntax.

## How we did it without downtime

1. **Ran both controllers in parallel.** Ingress NGINX and kgateway coexisted during the migration, each
   fronting a different, controlled slice of traffic.
2. **Migrated service by service.** We wrote a small script to translate existing `Ingress` resources into
   `HTTPRoute` equivalents, then validated behavior against the old Ingress before cutting DNS/weight over.
3. **Kept TLS termination and cert-manager integration first-class.** Since `Gateway` resources support
   `cert-manager` annotations directly, certificate issuance kept working without special-casing.
4. **Decommissioned Ingress NGINX last**, only after every route had been running cleanly on kgateway for a
   full deployment cycle.

## What I'd tell someone starting this migration

Don't try to do a big-bang cutover. The value of running both controllers side-by-side during the transition
is that a bad `HTTPRoute` translation only affects the one service you're migrating — not your whole
platform's ingress traffic. Treat it the same way you'd treat any other zero-downtime infrastructure change:
incrementally, with a fast rollback path at every step.
