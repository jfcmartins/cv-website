// Single source of truth for identity/deploy values used across
// astro.config.mjs and the site itself. Change a rename (GitHub repo,
// username, domain) here once instead of hunting through every file.

export const GITHUB_USERNAME = 'jfcmartins';
export const GITHUB_REPO = 'jorgemartins-site';
export const SITE_DOMAIN = 'jorgemartins.xyz';

export const GITHUB_URL = `https://github.com/${GITHUB_USERNAME}`;
export const GITHUB_PAGES_URL = `https://${GITHUB_USERNAME}.github.io`;
