// @ts-check
import { defineConfig } from 'astro/config';

// GitHub Pages serves project sites from a /<repo> subpath unless a custom
// domain is attached. The GITHUB_PAGES env var (set only in the Pages
// workflow) switches `site`/`base` for that subpath; the AWS deploy path
// keeps building for the root of the custom domain.
const isGithubPages = process.env.GITHUB_PAGES === 'true';

// https://astro.build/config
export default defineConfig({
  site: isGithubPages ? 'https://jfcmartins.github.io' : 'https://jorgemartins.xyz',
  base: isGithubPages ? '/jorgemartins-site' : '/',
});
