// @ts-check
import { defineConfig } from 'astro/config';
import { GITHUB_REPO, GITHUB_PAGES_URL, SITE_DOMAIN } from './site.config.mjs';

// GitHub Pages serves project sites from a /<repo> subpath unless a custom
// domain is attached. The GITHUB_PAGES env var (set only in the Pages
// workflow) switches `site`/`base` for that subpath; the AWS deploy path
// keeps building for the root of the custom domain.
const isGithubPages = process.env.GITHUB_PAGES === 'true';

// https://astro.build/config
export default defineConfig({
  site: isGithubPages ? GITHUB_PAGES_URL : `https://${SITE_DOMAIN}`,
  base: isGithubPages ? `/${GITHUB_REPO}` : '/',
});
