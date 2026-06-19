---
name: publish-typst-universe
description: Use when preparing a Typst Universe package submission or update, creating the typst/packages submission tree, validating a Typst package release, drafting the PR body, or responding to Typst Universe PR checks. Use this for any request mentioning Typst Universe, typst/packages, package publishing, package submission guidelines, preview namespace releases, or template package PRs.
---

# Typst Universe Publish

Prepare a Typst package or template for submission to `typst/packages` without relying on stale local assumptions. The central invariant: the submission must match the current upstream package repository docs, and the package's `compiler` field is a support promise, not a CI workaround.

## Fail Conditions

Stop and ask the user when any of these would change the release contract:

- Lowering `compiler` below the version the package was designed for.
- Moving, deleting, or force-updating an existing release tag after it has been published or announced.
- Renaming the package or changing the version.
- Creating or updating a PR when the user only asked to prepare files or a branch.
- Choosing whether extra docs/examples belong in `commit & exclude` vs `don't commit` when project intent is unclear.
- A Typst app/package bot failure contradicts local validation.

If tools cannot verify the exact Typst version, package check result, or PR state, report that explicitly instead of guessing.

## Inputs

Gather or infer these before editing:

- Package name and version from `typst.toml`.
- Package type: library, template, or both.
- Source repository release policy: tags, releases, changelog, branch policy.
- Target namespace; default for public submissions is `preview`.
- Whether the user wants: submission tree only, fork branch push, PR body, or actual PR creation.
- Existing fork path or fork URL. Do not hard-code machine-specific paths.

Default PR policy: prepare the branch and PR body only. Create a PR only if the user explicitly asks.

## Workflow

### 1. Read current upstream Typst package docs every time

Do not bundle or paraphrase a permanent copy of the rules into the project. The upstream docs change. Read them remotely at the start of each publishing pass:

- `https://github.com/typst/packages/blob/main/docs/README.md`
- `https://github.com/typst/packages/blob/main/docs/manifest.md`
- `https://github.com/typst/packages/blob/main/docs/tips.md#what-to-commit-what-to-exclude`
- `https://github.com/typst/packages/blob/main/docs/typst.md`
- `https://github.com/typst/packages/blob/main/docs/documentation.md`
- `https://github.com/typst/packages/blob/main/docs/licensing.md`
- `https://github.com/typst/packages/blob/main/docs/resources.md`

Also read when relevant:

- `https://github.com/typst/packages/blob/main/docs/CATEGORIES.md`
- `https://github.com/typst/packages/blob/main/docs/DISCIPLINES.md`

Extract only the rules needed for the current submission. If the upstream docs differ from this skill, follow upstream docs and call out the mismatch.

### 2. Inspect the source package

Read the project instructions and package-facing files:

- `typst.toml`
- public entrypoint, usually `lib.typ`
- package source files
- `template/**` for template packages
- `README.md` and any linked local docs
- `LICENSE` and any template-specific license files
- release policy files, if present
- validation scripts, if present

Check imports in template and example files:

- Template files must use absolute package imports such as `@preview/name:version`.
- Direct package source files should use local imports when needed to avoid cyclic package imports.
- README examples should use `@preview/name:version`.

### 3. Decide the submission file layout from upstream docs

Apply the upstream `What to commit? What to exclude?` model file-by-file.

Typical `commit & include` files:

- `typst.toml`
- package entrypoint and implementation files
- files required by the package at runtime
- all files under `template/**` that initialized projects need
- `README.md`
- `LICENSE`
- template thumbnail, if the manifest references one

Typical `commit & exclude` files:

- Local docs linked from README and useful on Typst Universe.
- Local examples linked from README and useful to readers.
- README images, manuals, or generated documentation that should remain browsable but not downloaded as part of the package archive.

Typical `don't commit` files:

- tests and validation fixtures
- build outputs
- release scripts and local packaging scripts
- CI/config files that are not useful to package users
- editor/agent files
- `.git`, submodules, OS junk, hidden placeholders copied only to keep empty directories
- examples/manuals not linked from README

Do not assume `exclude` removes files from the PR diff. It only excludes committed package files from the Typst package archive. Files that should not be visible in the PR must not be committed to the package directory.

### 4. Interview on real choices

Ask concise questions when choices affect maintainability or user experience. Common questions:

- Should linked extra docs/examples be included as `commit & exclude`, or should the PR be minimal?
- Should empty starter directories be preserved, knowing placeholders may be copied into initialized projects?
- Should a compiler mismatch be handled by keeping the support baseline, lowering it after real compatibility testing, or asking maintainers?
- Should an existing release tag be retargeted because the release has not been accepted yet, or should a new patch version be created?

Prefer the conservative option when the choice is not material. Ask only when the answer changes the release contract.

### 5. Prepare a clean deploy tree

Generate a clean tree that mirrors the package repository layout:

```text
packages/preview/<package-name>/<version>/
```

Use project scripts if they exist, but verify the resulting tree against the upstream docs. Otherwise copy files explicitly according to the layout decision.

For `typst.toml`:

- Ensure folder name and manifest name/version match.
- Keep `README.md` and `LICENSE` out of `exclude`.
- Put only committed documentation/archive-heavy files in `exclude`.
- Do not add `homepage` unless there is a dedicated docs site; prefer `repository` for a source repository.
- Treat `compiler` as the minimum supported Typst version. Do not lower it just to satisfy a bot.

### 6. Validate locally

Run the checks that match the upstream docs and project policy:

```bash
typst-package-check check <package-dir>
typos <package-dir>
typst init --package-path <deploy-root>/packages @preview/<name>:<version> <smoke-dir>
typst compile --package-path <deploy-root>/packages <smoke-dir>/main.typ <smoke-dir>/main.pdf
```

For template packages, the initialized project must compile out-of-the-box.

If changing `compiler`, verify with the actual minimum compiler version, not only the newest local Typst. Download an official Typst release binary if needed. A successful compile on a newer compiler does not prove compatibility with the declared minimum.

Warnings are not automatically blockers, but record them. Compiler errors are blockers unless maintainers explicitly accept the reason.

### 7. Prepare the typst/packages fork with sparse checkout

Use sparse checkout so contributors do not need the full package repository. General shape:

```bash
git clone --depth 1 --no-checkout --filter=tree:0 <fork-url> typst-packages
cd typst-packages
git sparse-checkout init --cone
git sparse-checkout set docs packages/preview/<package-name>
git remote add upstream git@github.com:typst/packages.git
git config remote.upstream.partialclonefilter tree:0
git checkout main
```

If a clone already exists, inspect its worktree and branch before deleting or reusing it. Never remove a dirty clone without user approval.

Create a submission branch from current upstream `main`, copy the clean package directory into `packages/preview/<name>/<version>/`, commit, and push to the contributor fork only when requested.

### 8. Draft the PR body

PR title should be exactly:

```text
<name>:<version>
```

Use the upstream template. For a new package, include:

- new package checkbox checked
- concise description: what it does and why useful
- naming-rule explanation
- manifest checkbox
- README checkbox
- license checkbox
- local test checkbox
- exclude checkbox
- template license checkbox when the package has a template

For template naming, explain the unique/non-descriptive prefix and the descriptive suffix. If the package is unofficial, say so when relevant.

### 9. Sync source release only when appropriate

If preparing the package changes the source snapshot while keeping the same version:

- Update changelog as a release snapshot summary, not a log of packaging cleanup.
- Re-run validation before moving release metadata.
- Retarget an existing annotated tag/release only when the version has not been accepted/published downstream and the user approves.
- After a version is accepted by Typst Universe, do not rewrite it. Make a new patch release instead.

When retargeting a release:

- Push the source branch first.
- Update the annotated tag.
- Force-push the tag only after confirming this is intended.
- Update GitHub Release target/body to match the new tag target.
- Record tag object and target commit in handoff notes.

### 10. Respond to PR checks

Inspect both GitHub Actions checks and Typst app/package bot annotations.

If a Typst app bot uses an older compiler than the manifest's `compiler`:

- Do not immediately lower `compiler`.
- Verify whether the package truly works with the older compiler.
- Search nearby open PRs for similar failures and maintainer comments.
- Ask the user whether to wait, comment, or change the support baseline.

If maintainers request changes, apply them in source first, regenerate the submission tree, validate, then force-push the existing PR branch. Do not create a new PR unless asked.

## Quick Reference

### File layout decision table

| File type | Commit? | Include in archive? | Notes |
|---|---:|---:|---|
| `typst.toml` | yes | yes | manifest name/version must match path |
| `lib.typ`, `src/**` | yes | yes | package runtime |
| `template/**` | yes | yes | template initialization must work |
| `README.md` | yes | yes | Typst Universe displays it |
| `LICENSE` | yes | yes | do not exclude |
| linked docs/examples | yes | usually no | put in `exclude` if not runtime-critical |
| tests/fixtures | no | no | keep in source repo only |
| build outputs/PDFs | usually no | no | if committed for docs, exclude |
| release scripts | usually no | no | source repo only |
| README images | yes if linked | no | commit & exclude |

### Minimal validation command set

```bash
typst-package-check check <package-dir>
typos <package-dir>
typst init --package-path <package-root>/packages @preview/<name>:<version> <smoke-dir>
typst compile --package-path <package-root>/packages <smoke-dir>/main.typ <smoke-dir>/main.pdf
```

### PR title

```text
<name>:<version>
```

## Common Mistakes

- Treating `exclude` as a PR diff filter. It is not; uncommitted is the only way to remove files from the PR.
- Copying tests, build scripts, agent files, or release notes into `typst/packages` just because they exist in the source repo.
- Lowering `compiler` to pass a bot without proving true compatibility.
- Forgetting that template starter files are copied into user projects.
- Using relative imports in template files.
- Linking README files to docs/examples that were not committed to the package directory or stable external URLs.
- Excluding `README.md` or `LICENSE`.
- Copying `.git` into the package repository and accidentally creating a submodule.
- Creating a new PR instead of force-pushing the existing branch for review fixes.
- Moving stable tags after downstream publication instead of making a patch version.

## Handoff Notes

At the end of a publishing pass, write or update a handoff note with:

- source branch, commit, tag object, tag target, release URL
- fork branch, commit, remote branch state
- PR URL and check status
- exact validation commands run
- submitted file layout and intentionally excluded files
- unresolved maintainer comments or bot failures
