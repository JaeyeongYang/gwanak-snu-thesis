# Contributing

This project uses GitHub Flow for contributions, [Semantic Versioning 2.0.0](https://semver.org/) for versions, and immutable Git tags for stable releases.

## Development workflow

- `main` is the default development branch.
- `main` must stay buildable and releasable.
- `main` may contain changes that have not been released yet.
- Stable versions are identified by Git tags and GitHub Releases, not by the current `main` HEAD.
- Do not maintain a separate `next`, `develop`, or release-candidate branch by default.

Use short-lived branches from `main`:

- `feat/<name>` for features.
- `fix/<name>` for bug fixes.
- `docs/<name>` for documentation-only changes.
- `chore/<name>` for maintenance that does not affect the public template behavior.

Merge changes back to `main` through pull requests after the relevant checks pass.

## Public API

Semantic Versioning applies to the public template API and documented behavior.

Public API includes:

- The package entrypoint exposed through `lib.typ`.
- The exported `snu-thesis(...)` API.
- Public argument names, types, defaults, and accepted values.
- Documented behavior in `README.md` and `SPECS.md`.
- User-visible output behavior such as frontmatter order, degree-specific rendering, page setup, appendix numbering, and bibliography ownership.

Public API does not include:

- Private helpers under `src/`.
- Internal file organization.
- Test fixture organization.
- Refactors that preserve the documented API and output behavior.

## Versioning

Use SemVer versions in `typst.toml` and matching `vX.Y.Z` Git tags.

Before `1.0.0`, use strict `0.y.z` semantics:

- `0.MINOR.0` for breaking changes or new public functionality.
- `0.MINOR.PATCH` for backward-compatible bug fixes, documentation fixes, and test-only changes.

After `1.0.0`, use standard SemVer:

- `MAJOR` for backward-incompatible public API or documented output behavior changes.
- `MINOR` for backward-compatible public functionality.
- `PATCH` for backward-compatible bug fixes.

Reset lower-order components when incrementing a higher-order component.

Examples:

- `0.1.0` -> `0.2.0`: breaking API change before `1.0.0`.
- `0.2.0` -> `0.2.1`: backward-compatible bug fix before `1.0.0`.
- `1.2.3` -> `2.0.0`: breaking change after `1.0.0`.
- `1.2.3` -> `1.3.0`: backward-compatible feature after `1.0.0`.
- `1.2.3` -> `1.2.4`: backward-compatible bug fix after `1.0.0`.

## Tags

- Stable release tags use `vX.Y.Z`.
- Use annotated tags.
- Do not use release-candidate tags by default.
- Do not move or rewrite a pushed release tag.
- If a release is wrong, publish a new patch release instead of editing the existing tag.

Example:

```bash
git tag -a v0.2.0 -m "Release v0.2.0"
git push origin v0.2.0
```

## Release process

Create a short-lived release branch from `main` and open a pull request back to `main` when the current `main` state is ready to release.

The release pull request should only contain release bookkeeping:

1. Update `typst.toml` to the target version.
2. Move `CHANGELOG.md` entries from `Unreleased` to `vX.Y.Z - YYYY-MM-DD`.
3. Add a fresh empty `Unreleased` section.
4. Update `README.md`, `README.ko.md`, or `SPECS.md` only if the release changes user-facing instructions or implemented behavior.
5. Run the release verification commands from `TESTING.md`.

After the release pull request is merged:

1. Tag the merge commit with `vX.Y.Z`.
2. Push the tag.
3. Create a GitHub Release from the tag using the finalized changelog entry.

## Hotfixes

For a released-version bug:

1. Branch from `main` if `main` still contains the intended patch base.
2. If `main` has moved past the released line in an incompatible way, branch from the affected release tag.
3. Apply the minimal fix.
4. Merge through a pull request.
5. Release the next patch version.

Never rewrite the old release tag.
