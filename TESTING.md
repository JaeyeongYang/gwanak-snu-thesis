# Testing

Generated outputs go under `build/`. The directory is ignored by git.

## Typst Universe deploy tree

Prepare the exact directory shape that is copied into the `typst/packages` repository and run release checks against that clean copy.

```bash
python3 scripts/prepare-universe-package.py
```

This creates:

```text
build/deploy/packages/preview/gwanak-snu-thesis/0.1.0/
```

The script copies only submission files, checks the thumbnail constraints, runs `typst-package-check`, runs `typos`, initializes the template through `typst init --package-path`, and compiles the initialized project. Use `--no-check` only when you need to inspect the generated deploy tree without running tools.

## Positive compile checks

The public examples use the published-package import, so mirror the checkout into a local package path before compiling them.

```bash
mkdir -p build
BASE=$(python3 - <<'PY'
from pathlib import Path
import shutil, tempfile
root = Path.cwd()
base = Path(tempfile.mkdtemp(prefix="gwanak-snu-thesis-pkg-"))
pkg = base / "packages" / "preview" / "gwanak-snu-thesis" / "0.1.0"
pkg.mkdir(parents=True)
for file in ["typst.toml", "README.md", "README.ko.md", "LICENSE", "lib.typ", "thumbnail.png"]:
    src = root / file
    if src.exists():
        shutil.copy2(src, pkg / file)
for directory in ["src", "template"]:
    shutil.copytree(root / directory, pkg / directory)
print(base)
PY
)
typst compile --package-path "$BASE/packages" examples/master.typ build/example-master.pdf
typst compile --package-path "$BASE/packages" examples/phd.typ build/example-phd.pdf
typst compile --package-path "$BASE/packages" examples/bachelor.typ build/example-bachelor.pdf
typst compile --root . tests/master-ko.typ build/master-ko.pdf
typst compile --root . tests/appendix-counters.typ build/appendix-counters.pdf
typst compile --root . tests/bachelor-ko.typ build/bachelor-ko.pdf
typst compile --root . tests/official-phd-ko.typ build/official-phd-ko.pdf
typst compile --root . tests/official-en-with-ko-abstract.typ build/official-en-with-ko-abstract.pdf
typst compile --root . tests/bibliography-content.typ build/bibliography-content.pdf
typst compile --root . tests/draft-bachelor.typ build/draft-bachelor.pdf
typst compile --root . tests/draft-master.typ build/draft-master.pdf
typst compile --root . tests/draft-phd.typ build/draft-phd.pdf
typst compile --root . tests/paper-size-a4.typ build/paper-size-a4.pdf
```

## Negative compile checks

These fixtures must fail.

```bash
mkdir -p build
for file in \
  tests/invalid-degree.typ \
  tests/invalid-committee-count-master.typ \
  tests/invalid-committee-count-phd.typ \
  tests/invalid-advisor-overlap.typ \
  tests/invalid-old-api.typ \
  tests/invalid-profile-arg.typ \
  tests/invalid-paper-size.typ \
  tests/invalid-paper-size-official.typ \
  tests/invalid-school-en-sub.typ \
  tests/invalid-school-ko-university.typ \
  tests/invalid-school-en-university.typ \
  tests/invalid-department-arg.typ
  do
    if typst compile --root . "$file" "build/$(basename "$file" .typ).pdf"; then
      echo "unexpected success: $file"
      exit 1
    else
      echo "expected failure: $file"
    fi
  done
```

## Visual spot checks

Run after layout or typography changes. Reuse the `BASE` local package path from the positive compile checks for public examples.

```bash
typst compile --package-path "$BASE/packages" examples/master.typ 'build/example-master-{p}.png'
typst compile --package-path "$BASE/packages" examples/phd.typ 'build/example-phd-{p}.png'
typst compile --package-path "$BASE/packages" examples/bachelor.typ 'build/example-bachelor-{p}.png'
typst compile --root . tests/draft-bachelor.typ 'build/draft-bachelor-{p}.png'
```

## Local Universe template smoke

This checks the same package-style import used by `typst init` users.

```bash
BASE=$(python3 - <<'PY'
from pathlib import Path
import shutil, tempfile
root = Path.cwd()
base = Path(tempfile.mkdtemp(prefix="gwanak-snu-thesis-pkg-"))
pkg = base / "packages" / "preview" / "gwanak-snu-thesis" / "0.1.0"
pkg.mkdir(parents=True)
for file in ["typst.toml", "README.md", "README.ko.md", "LICENSE", "lib.typ", "thumbnail.png"]:
    src = root / file
    if src.exists():
        shutil.copy2(src, pkg / file)
for directory in ["src", "template"]:
    shutil.copytree(root / directory, pkg / directory)
(base / "init").mkdir()
print(base)
PY
)

typst init --package-path "$BASE/packages" @preview/gwanak-snu-thesis:0.1.0 "$BASE/init/my-thesis"
typst compile --package-path "$BASE/packages" "$BASE/init/my-thesis/main.typ" "$BASE/init/my-thesis/main.pdf"
```

## Thumbnail regeneration

Generate the thumbnail from the initialized local preview package, not from a direct source import.

```bash
typst compile --package-path "$BASE/packages" --pages 1 --ppi 144 "$BASE/init/my-thesis/main.typ" thumbnail.png
```

Expected constraints:

- PNG.
- Long side at least 1080px.
- File size under 3MiB.
