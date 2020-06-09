# Build Debian / Ubuntu package

Checkout `debian` branch. The branch is prepared to be used with `gbp`.

* Build a source only package:
  `gbp buildpackage --git-builder="debuild -S" --git-ignore-new`
* Build binary packages with `sbuild`:
  `gbp buildpackage --git-builder="sbuild -A" --git-ignore-new`

Note: Debian packages are deprecated due to minimal usage.
