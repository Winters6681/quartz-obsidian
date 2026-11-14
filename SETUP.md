# Setup checklist

What is already in this repo, and what is left for you to do by hand. Steps are in order; each phase works on its own.

## Already in the repo

| Piece | Where |
|---|---|
| Build twice, deploy to Cloudflare Pages | `.github/workflows/ci.yml` |
| Link checker that works on a private repo | `.github/workflows/lychee.yml` |
| Site layout: `mocs/`, `literature/`, `permanent/`, `projects/`, `pointers/`, `pages/` | `content/` |
| Note templates (literature, permanent, MOC, pointer, project) | `content/templates/` (never published) |
| Vault to repo copy script | `scripts/publish.sh` |
| PDFs kept out of Git | `.gitignore` |

The workflow builds a **private** site (every note except `draft: true`) and a **public** site (only notes with `publish: true`). It deploys nothing until the Cloudflare secrets exist, and the public site stays off until you set `PUBLIC_SITE_ENABLED`.

## Phase 0: Make the repo private (do this first)

- [ ] GitHub → Settings → General → Danger Zone → Change visibility → **Private**. The repo is public today, so anything pushed to `content/` is readable by anyone, including notes the site hides.
- [ ] Settings → Pages → set Source to "None" if GitHub Pages was turned on.
- [ ] Clone the repo to a folder **outside** pCloud (for example `~/research-notes`).

## Phase 1: Private site, live

- [ ] Create a Cloudflare account. Workers & Pages → Create → Pages → **Upload assets** → name it `research-private` → upload any placeholder `index.html`.
- [ ] Note the address Cloudflare gives it. If `research-private.pages.dev` was taken it will have a suffix.
- [ ] Cloudflare → My Profile → API Tokens → Create Token → Custom → permission **Account / Cloudflare Pages / Edit**.
- [ ] GitHub → Settings → Secrets and variables → Actions → **Secrets**: add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`.
- [ ] Same page → **Variables**: add `PRIVATE_BASE_URL` with the real address (no `https://`), only if it differs from `research-private.pages.dev`.
- [ ] Merge this branch into `main`. Watch the Actions tab; the `private` job should deploy.
- [ ] Cloudflare → Zero Trust → pick a team name → Free plan.
- [ ] Pages project → Settings → enable the access policy. Then Zero Trust → Access → Applications → edit it so it covers the main `pages.dev` address, not only `*.research-private.pages.dev` previews.
- [ ] Policy: Allow → Emails → your address (add collaborators one by one).
- [ ] Open the site in a private browser window. It must ask for an email code.

## Phase 2: Connect the vault

- [ ] In the Obsidian vault, create `mocs/`, `literature/`, `permanent/`, `projects/`, `pointers/` if missing, and copy the files in `content/templates/` into the vault's `templates/`.
- [ ] Run `VAULT=/path/to/vault scripts/publish.sh`. It copies those five folders, commits and pushes. `inbox/`, `daily/` and `archive/` are never copied.
- [ ] Edit `content/index.md`: add the Notion dashboard link and your MOCs.
- [ ] Publish at most a few times a day.

## Phase 3: Files and pointers

- [ ] pCloud: `Research/papers/`, `Research/talks/`, `Research/data/`, with public and private material in separate folders.
- [ ] In each literature note, put the pCloud link in the `file:` property.
- [ ] Add a pointer note for each Claude chat or Notion page worth finding again.

## Phase 4: Public site

- [ ] Create a second Pages project, `research-public`, the same way. Do **not** enable an access policy on it.
- [ ] GitHub → Variables: `PUBLIC_SITE_ENABLED` = `true` (and `PUBLIC_BASE_URL` if the address has a suffix).
- [ ] Mark notes you stand behind with `publish: true` and push.
- [ ] Test: search the public site for a word that appears only in a private note. Nothing should come up.
- [ ] Optional: custom domain. Attach it to each project, set the two `*_BASE_URL` variables, and add a self-hosted Access application for the private domain.

## Phase 5: VPS

Only when you need a file over 25 MiB served, a searchable PDF library, or a tool with a backend.

## Preview on your own machine

`./preview.sh` serves the private view at `http://localhost:8080`.
