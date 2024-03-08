# Github Actions Workflow for Node Package Manager

## Introduction

This is a HeadVer auto tagging workflows written in YAML that runs on Github Actions. 

### Prerequisite

We assume that the 'head' value is read from `package.json` file as below format.

```json
{
  "version": "0.1.0"
}
```

A similar approach could be used to manage 'head' value located in any other file.

### Variables

- VERSION_PREFIX: `v`
- VERSION_HEAD: the first digit of the version from `package.json` 
- VERSION_YEAR: last two digits of year of ISO week number
- VERSION_WEEK: ISO week number, with Monday as first day of week (01..53)
- VERSION_BUILD: A unique number for each execution of a specific workflow in the repository.

## How to Use
The repository's Workflow permissions must be `Read and write permissions`. Please check your repository's Settings > Actions page.

1. Make a `.yml` file in `.github/workflows`
2. Write workflow code by referring to example code below `Tagging job` section.
3. Make sure that contents's permissions is `write` and `package.json` has version information.

Github Actions documentation [here](https://docs.github.com/en/actions). 


## Example Code

```yaml
name: Vite Github Pages Deploy

on:
  push:
    branches: ["main"]

  workflow_dispatch:

permissions:
  contents: write
  pages: write
  id-token: write

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Setup Pages
        uses: actions/configure-pages@v3
      - name: Install
        run: npm i
      - name: Build
        run: npm run build
        env:
          NODE_ENV: production
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: ./dist

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2

  # Tagging job
  tag:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          fetch-depth: "0"
      - name: Read packages.json
        run: |
          echo "PACKAGE_JSON=$(jq -c . < package.json)" >> $GITHUB_ENV
      - name: Generate tag version (headver)
        run: |
          VERSION_PREFIX="v"
          VERSION_HEAD=$(cut -d '.' -f 1 <<< ${{ fromJson(env.PACKAGE_JSON).version }})
          VERSION_YEAR=$(date +%g)
          VERSION_WEEK=$(date +%V)
          VERSION_BUILD=${{github.run_number}}
          NEW_TAG="${VERSION_PREFIX}${VERSION_HEAD}.${VERSION_YEAR}${VERSION_WEEK}.${VERSION_BUILD}"
          echo "Generated new tag: $NEW_TAG"
          echo "NEW_TAG=$NEW_TAG" >> $GITHUB_ENV
      - name: Push Git Tag
        run: |
          git config user.name "GitHub Actions"
          git config user.email "github-actions@users.noreply.github.com"
          git tag $NEW_TAG
          git push origin $NEW_TAG
```
