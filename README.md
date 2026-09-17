# The Ultimate Balloon Studio — Public Resources

Maintained by **AB Event Decor LLC** (Essex, Vermont, United States).

This repository exists for two narrow purposes:

1. **Update manifest.** A small public JSON file that installed copies of
   The Ultimate Balloon Studio can read to learn whether a newer version has
   been published. See [`v1/version.json`](v1/version.json).
2. **Corresponding source for LGPL-covered libraries.** Unmodified upstream
   source archives for the Qt and Qt for Python libraries that The Ultimate
   Balloon Studio links against, published as release assets so that
   recipients of the binary have network access to the corresponding source.
   See the [Releases](../../releases) page.

This repository does **not** contain the source code of The Ultimate Balloon
Studio itself, which is proprietary, and it does **not** host the installer.
The installer is distributed from the product / download page.

## Corresponding source

The Ultimate Balloon Studio dynamically links the following libraries, which
are used under the **GNU Lesser General Public License version 3**. LGPL-3.0
incorporates the terms of **GNU General Public License version 3**, and both
license texts ship inside the installed application folder.

| Component | Version | Upstream source |
| --- | --- | --- |
| Qt | 6.9.3 | <https://download.qt.io/official_releases/qt/6.9/6.9.3/single/> |
| PySide6 (Qt for Python) | 6.9.3 | <https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.9.3-src/> |
| shiboken6 | 6.9.3 | same `pyside-setup` source tree as PySide6 |

The Qt Project download servers are not under our control. AB Event Decor LLC
retains its own copies of the same archives for as long as it distributes the
corresponding binary, and publishes them here as release assets. Each release
includes a `SHA256SUMS.txt` so the archives can be verified.

The archives published here are byte-for-byte unmodified upstream releases.
No AB Event Decor LLC modifications have been made to Qt, PySide6, or
shiboken6.

## Written offer

If a release asset is unavailable, email **support@abeventdecor.com** with the
subject `LGPL corresponding source request`, naming the product version and
which archives you need. Requests can also be sent to:

```
AB Event Decor LLC
45 Clover Drive
Essex, VT 05452
United States
```

## License of this repository's own contents

The README and the update manifest in this repository are informational.
The bundled third-party source archives remain under their own upstream
licenses (LGPL-3.0 / GPL-3.0 and the additional licenses enumerated in the
archives themselves).
