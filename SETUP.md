# Ryan Wenstrom Portfolio — Batch v1

This package is designed to be copied into the root of:

`C:\Users\ryanm\GitHub\ryan-wenstrom-portfolio.github.io`

It intentionally replaces the current Astro source with a complete recruiter-facing v1 while preserving the design direction already approved.

## What is included

- Finished homepage
- Four project case-study pages
- Subtle Leadership & Athletics section
- Updated Experience locations
- About + Education
- Analytics and Finance resume PDFs
- Header/footer
- 404 page
- NBA screenshots
- All-American recognition images
- Asset download + Neo4j interactive patch script

## Before copying

Stay on the working branch:

`phase-4-foundation`

Optional safety checkpoint:

```powershell
git status
git add .
git commit -m "Checkpoint before full portfolio v1"
git push origin phase-4-foundation
```

## Install the package

Extract this ZIP.

Copy the contents of the extracted `ryan-portfolio-v1` folder into the repository root and allow Windows to replace files when prompted.

The package does not contain `node_modules`, `package.json`, `package-lock.json`, or `tsconfig.json`, so your working Astro installation remains intact.

## Download the remaining public project assets

From the repository root:

```powershell
.\setup-assets.ps1
```

This downloads the latest public visuals from the four project repositories and rebuilds the Neo4j interactive network with the improved responsive/pan behavior.

## Production check

```powershell
npm run build
```

Then:

```powershell
npm run dev
```

Open:

`http://localhost:4321`

Also test:

- `/projects/mortgage-approval-analytics/`
- `/projects/sql-analytics/`
- `/projects/nba-player-role-analytics/`
- `/projects/neo4j-stock-network-analysis/`
- `/interactive/neo4j-stock-network.html`
- both resume links

## Important

Do not commit the final batch yet if you want ChatGPT to perform a visual audit first.

The next recommended step is to send desktop and mobile screenshots, or publish a preview and ask for a consolidated recruiter/accessibility/link audit.
