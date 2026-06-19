#!/usr/bin/env python3
"""Prepare and validate the Typst Universe submission tree.

The generated tree mirrors the typst/packages repository layout:

  build/deploy/packages/preview/{name}/{version}/

It intentionally copies only files that should be submitted to Typst Universe,
then runs the release checks against that clean copy.
"""

from __future__ import annotations

import argparse
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys

PACKAGE_NAMESPACE = "preview"
DEFAULT_DEPLOY_ROOT = Path("build/deploy")

COPY_FILES = (
    "typst.toml",
    "README.md",
    "README.ko.md",
    "LICENSE",
    "thumbnail.png",
    "lib.typ",
    "SPECS.md",
    "TESTING.md",
    "CONTRIBUTING.md",
    "CHANGELOG.md",
)

COPY_DIRS = (
    "src",
    "template",
    "examples",
    "scripts",
)

FORBIDDEN_NAMES = {
    ".DS_Store",
}


def fail(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def read_manifest(root: Path) -> dict[str, str]:
    manifest_path = root / "typst.toml"
    if not manifest_path.exists():
        fail("typst.toml is missing")

    text = manifest_path.read_text(encoding="utf-8")

    def string_field(name: str) -> str:
        match = re.search(rf'^\s*{re.escape(name)}\s*=\s*"([^"]+)"\s*$', text, re.MULTILINE)
        if not match:
            fail(f"typst.toml is missing string field {name!r}")
        return match.group(1)

    return {
        "name": string_field("name"),
        "version": string_field("version"),
        "thumbnail": string_field("thumbnail"),
    }


def copy_package(root: Path, package_dir: Path) -> None:
    if package_dir.exists():
        shutil.rmtree(package_dir)
    package_dir.mkdir(parents=True)

    for relative in COPY_FILES:
        source = root / relative
        if not source.exists():
            fail(f"required deploy file is missing: {relative}")
        shutil.copy2(source, package_dir / relative)

    for relative in COPY_DIRS:
        source = root / relative
        if not source.is_dir():
            fail(f"required deploy directory is missing: {relative}")
        shutil.copytree(source, package_dir / relative)


def assert_no_forbidden_files(package_dir: Path) -> None:
    for path in package_dir.rglob("*"):
        if path.name in FORBIDDEN_NAMES:
            fail(f"forbidden file copied into deploy tree: {path.relative_to(package_dir)}")


def check_thumbnail(package_dir: Path, thumbnail: str) -> None:
    path = package_dir / thumbnail
    if not path.exists():
        fail(f"thumbnail is missing: {thumbnail}")
    size = path.stat().st_size
    if size > 3 * 1024 * 1024:
        fail(f"thumbnail exceeds 3 MiB: {size} bytes")

    with path.open("rb") as file:
        if file.read(8) != b"\x89PNG\r\n\x1a\n":
            fail("thumbnail must be a PNG")
        file.read(4)
        if file.read(4) != b"IHDR":
            fail("thumbnail PNG is missing IHDR")
        width, height = struct.unpack(">II", file.read(8))

    if max(width, height) < 1080:
        fail(f"thumbnail long side must be at least 1080 px; got {width}x{height}")

    print(f"thumbnail: {width}x{height}px, {size} bytes")


def executable(name: str) -> str:
    found = shutil.which(name)
    if found:
        return found

    cargo_bin = Path.home() / ".cargo" / "bin" / name
    if cargo_bin.exists() and os.access(cargo_bin, os.X_OK):
        return str(cargo_bin)

    fail(f"required executable is not available: {name}")


def run(command: list[str], cwd: Path) -> None:
    print("$ " + " ".join(command))
    subprocess.run(command, cwd=str(cwd), check=True)


def run_checks(root: Path, deploy_root: Path, package_dir: Path, name: str, version: str) -> None:
    typst_package_check = executable("typst-package-check")
    typos = executable("typos")
    typst = executable("typst")

    run([typst_package_check, "check", str(package_dir)], cwd=root)
    run([typos, str(package_dir)], cwd=root)

    smoke_dir = deploy_root / "smoke" / name
    if smoke_dir.exists():
        shutil.rmtree(smoke_dir)
    smoke_dir.parent.mkdir(parents=True, exist_ok=True)

    package_path = deploy_root / "packages"
    run([
        typst,
        "init",
        "--package-path",
        str(package_path),
        f"@{PACKAGE_NAMESPACE}/{name}:{version}",
        str(smoke_dir),
    ], cwd=root)
    run([
        typst,
        "compile",
        "--package-path",
        str(package_path),
        str(smoke_dir / "main.typ"),
        str(smoke_dir / "main.pdf"),
    ], cwd=root)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Prepare a Typst Universe deploy tree and validate it.")
    parser.add_argument(
        "--deploy-root",
        type=Path,
        default=DEFAULT_DEPLOY_ROOT,
        help="Output root for the deploy tree. Defaults to build/deploy.",
    )
    parser.add_argument(
        "--no-check",
        action="store_true",
        help="Only prepare the deploy tree; skip typst-package-check, typos, and template smoke compile.",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    root = Path.cwd()
    deploy_root = args.deploy_root
    manifest = read_manifest(root)
    name = manifest["name"]
    version = manifest["version"]

    package_dir = deploy_root / "packages" / PACKAGE_NAMESPACE / name / version
    copy_package(root, package_dir)
    assert_no_forbidden_files(package_dir)
    check_thumbnail(package_dir, manifest["thumbnail"])

    if not args.no_check:
        run_checks(root, deploy_root, package_dir, name, version)

    print(f"prepared: {package_dir}")
    print(f"submit path: packages/{PACKAGE_NAMESPACE}/{name}/{version}")


if __name__ == "__main__":
    main()
