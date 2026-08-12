# Portfolio Audit Fixes v1.1

This patch contains the immediate corrections from the full-site audit:

- makes Lean Six Sigma Green Belt a direct hot link to the certificate image
- identifies the certificate as MoreSteam, Dec 2024
- removes the public Finance resume CTA and keeps one clear Resume action
- replaces the meta/defensive athletics sentence with recruiter-facing copy
- uses lightweight thumbnails for the All-American proof images while the links
  still open the full-resolution originals

## Apply

Copy the contents of this folder into the root of:

C:\Users\ryanm\GitHub\ryan-wenstrom-portfolio.github.io

Allow replacement of the three Astro component files.

Then remove the publicly hosted finance resume:

```powershell
Remove-Item public\resumes\Ryan_Wenstrom_Finance_Resume.pdf -ErrorAction SilentlyContinue
```

Run:

```powershell
npm run build
npm run dev
```

If everything looks correct:

```powershell
git add .
git status
git commit -m "Apply portfolio audit fixes"
git push origin phase-4-foundation
```
