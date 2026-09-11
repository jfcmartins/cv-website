# jorgemartins.xyz

Personal portfolio and blog for Jorge Martins — Staff Site Reliability Engineer.
Built with [Astro](https://astro.build), deployed to AWS (S3 + CloudFront) via
Terraform and GitHub Actions.

## Project structure

```
/
├── src/
│   ├── pages/          # index.astro, blog/index.astro, blog/[...slug].astro, 404.astro
│   ├── layouts/         # shared page shell (nav, theme toggle, footer)
│   ├── content/blog/    # blog posts as markdown
│   ├── data/resume.ts   # CV content (skills, experience, certs)
│   └── styles/          # global.css
├── infra/               # Terraform: S3, CloudFront, ACM, Route53, GitHub OIDC role
└── .github/workflows/   # CI build + deploy
```

## Local development

```sh
npm install
npm run dev       # http://localhost:4321
npm run build     # outputs to ./dist
npm run preview   # serve the production build locally
```

## Writing a blog post

Add a markdown file to `src/content/blog/`:

```md
---
title: "Post title"
description: "One-sentence summary."
pubDate: 2026-01-15
tags: ["kubernetes", "aws"]
draft: false
---

Post content in markdown.
```

It'll show up automatically on `/blog` and at `/blog/<filename>/`.

## Infrastructure (AWS via Terraform)

The site is a static export served from a **private** S3 bucket behind
**CloudFront** (Origin Access Control, not public bucket hosting), with a free
ACM certificate and Route53 DNS. See `infra/` for the full setup.

### One-time bootstrap

1. Buy the domain (e.g. `jorgemartins.xyz`) through your registrar of choice.
2. `cd infra && cp terraform.tfvars.example terraform.tfvars` and fill in
   `domain_name` and `github_repo`.
3. `terraform init && terraform plan && terraform apply`
4. Terraform creates a Route53 hosted zone — take the `name_servers` output
   and set them at your domain registrar (skip this if you registered the
   domain directly through Route53; it does this automatically).
5. Wait for DNS to propagate and the ACM certificate to validate (Terraform
   waits for this during `apply`).
6. Copy the `github_actions_role_arn`, `bucket_name`, `cloudfront_distribution_id`,
   and `aws_region` outputs into the GitHub repo's **Settings → Secrets and
   variables → Actions → Variables**:
   - `AWS_DEPLOY_ROLE_ARN`
   - `AWS_REGION`
   - `SITE_BUCKET_NAME`
   - `CLOUDFRONT_DISTRIBUTION_ID`

No long-lived AWS keys are stored anywhere — GitHub Actions assumes the
deploy role via OIDC for each run.

### Deploys

Every push to `main` (that isn't infra-only) builds the site and:

1. Syncs `dist/` to the S3 bucket.
2. Invalidates the CloudFront cache.

Changes under `infra/` are **not** auto-applied — run `terraform plan`/`apply`
manually from your machine (or wire up a separate Terraform CI job later).

### Remote state

Terraform starts with local state. Once you've applied once, bootstrap a
small state bucket and switch on the `backend "s3"` block in
`infra/versions.tf` (see the comments there).
