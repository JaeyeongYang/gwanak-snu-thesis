# AGENTS.md

Project-specific guidance for agents working on this repository.

## Project purpose

This repository is an unofficial Typst template for Seoul National University theses. The current release target is a practical Typst Universe-compatible template package, not an official submission guarantee or pixel-perfect reproduction of any source document.

## Source of truth

- Use `SPECS.md` for implemented template behavior.
- Use `README.md` for user-facing usage instructions.
- Use `TESTING.md` for verification commands.
- Use `CONTRIBUTING.md` for contribution workflow, branch policy, versioning, and release policy.
- Do not add local machine paths or external reference-source notes to project docs.

## Documentation language

- Keep `README.md` as the public English usage guide.
- Keep `README.ko.md` as the Korean guide with the same section structure as `README.md`.
- When changing user-facing usage docs, update both README files unless the change is intentionally language-specific.
- Keep prose in `README.md` English-only; Korean literals are fine inside Typst examples when demonstrating Korean thesis fields.
- Keep `SPECS.md` opening/overview sections in English. Korean text is fine where it specifies rendered labels, sample thesis metadata, or template output.

## Implementation structure

- `lib.typ` is the public package entrypoint.
- `src/snu-thesis.typ` is the public orchestrator and exports `snu-thesis`.
- `src/layout.typ` owns page size, margins, and page-numbering constants.
- `src/locale.typ` owns labels, language checks, and degree normalization.
- `src/typography.typ` owns font defaults, frontmatter typography helpers, heading style, and reference heading style.
- `src/frontmatter.typ` owns cover, approval, abstract, and acknowledgement rendering.
- `src/outlines.typ` owns contents, table list, and figure list rendering.
- `src/appendix.typ` owns appendix rendering and appendix-local counters.
- Keep helper functions private unless there is a strong user-facing need.

## Scope boundaries

Current supported scope:

- `body-language`: `"ko"` or `"en"`.
- `cover-language`: `"ko"`, `"en"`, or `none`.
- `approval-language`: `"ko"`.
- `degree`: `"bachelor"`, `"master"`, or `"phd"`.
- Paper size: `paper-size: "default"` resolves to explicit `190mm × 260mm`, with overrides for Typst paper strings or explicit `(width, height)` dictionaries.
- User-owned bibliography content via `bibliography: bibliography(..., title: none)`.
- Bachelor default path without approval-page or committee placeholders.
- Graduate approval pages with role-based committee data and advisor-last signer rendering.
- Appendix title prefixing and appendix-local figure/table/equation counters.
- Typst Universe starter under `template/`.

## Typst-specific gotchas

- `par.leading` is not CSS `line-height`. It is the distance between one line's bottom edge and the next line's top edge. The current body line model uses `text(top-edge: 0.8em, bottom-edge: -0.2em)` plus `par(leading: 1.04em)`.
- Test files under `tests/` import from the project root, so compile them with `--root .`.
- `build/` is ignored. Put generated PDFs and rendered PNG pages there.
- Do not make ambiguous B5 strings the default; `paper-size: "default"` uses explicit dimensions, and user-selected Typst paper strings are passed through intentionally.
- Typst warns for missing font families in fallback stacks. Do not suppress those warnings by trimming the cross-platform default stack without a user-facing reason.
- Appendix counters are reset inside the array-style `appendices` path. Prefer:
  ```typst
  appendices: (
    (title: [Appendix title], body: [Appendix body]),
  )
  ```

## Verification commands

Run the relevant commands from `TESTING.md` after behavior or layout changes.

## Change discipline

- Keep `README.md` concise and user-facing.
- Put implemented behavior in `SPECS.md`.
- Put test commands in `TESTING.md`.
- Update fixtures when changing behavior, especially appendices and degree-specific branches.
- Do not keep obsolete compatibility shims, duplicate examples, or stale generated-source folders.
