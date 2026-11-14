# Research notes

Notes from an Obsidian vault, published with [Quartz][] to two Cloudflare Pages sites: a private one with everything (behind Cloudflare Access) and a public one with only notes marked `publish: true`.

See [SETUP.md](SETUP.md) for the setup checklist. Based on [sosiristseng/template-quartz](https://github.com/sosiristseng/template-quartz).

[Quartz]: https://github.com/jackyzha0/quartz

## Preview your Quartz website

(See [Building your Quartz](https://quartz.jzhao.xyz/build) for details)

```bash
./preview.sh
```

The script checks out the pinned Quartz into `.quartz-preview/` (gitignored) and serves the site at `http://localhost:8080`. You can open the `content` folder in Obsidian (or other editors) to edit/add your notes while previewing.

## Updating the Quartz version

Edit the commit SHA in `quartz.version`.
