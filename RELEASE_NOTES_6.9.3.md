# Corresponding source — Qt 6.9.3 / Qt for Python 6.9.3

This release exists solely to provide network access to the **corresponding
source** for the LGPL-covered libraries that The Ultimate Balloon Studio
dynamically links against. It is not a release of The Ultimate Balloon Studio
and contains no AB Event Decor LLC software.

## What is here

| Asset | Component | Version |
| --- | --- | --- |
| `qt-everywhere-src-6.9.3.tar.xz` | Qt | 6.9.3 |
| `pyside-setup-everywhere-src-6.9.3.tar.xz` | PySide6 and shiboken6 (Qt for Python) | 6.9.3 |
| `SHA256SUMS.txt` | SHA-256 checksums for the two archives above | — |

## Provenance

Both archives are **byte-for-byte unmodified upstream releases**, retained from
the official Qt Project download servers:

- Qt 6.9.3 —
  <https://download.qt.io/official_releases/qt/6.9/6.9.3/single/>
- Qt for Python (pyside-setup) 6.9.3 —
  <https://download.qt.io/official_releases/QtForPython/pyside6/PySide6-6.9.3-src/>

Repository reference for the same Qt for Python project:
<https://code.qt.io/cgit/pyside/pyside-setup.git/> at the tag matching 6.9.3.

AB Event Decor LLC has made no modifications to Qt, PySide6, or shiboken6. The
application links against them as shared libraries and supplies no patched
build.

Each archive was verified against the MD5 checksums published upstream before
being republished here. Verify your download with:

```powershell
Get-FileHash -Algorithm SHA256 .\qt-everywhere-src-6.9.3.tar.xz
```

## Why it is published

The Ultimate Balloon Studio uses Qt, PySide6, and shiboken6 under the **GNU
Lesser General Public License version 3**. LGPL-3.0 incorporates the terms and
conditions of the **GNU General Public License version 3**, supplemented by
the additional permissions LGPL-3.0 sets out; both license texts ship inside
the installed application folder and are reachable from the application's
Help menu.

Because the application is distributed by download rather than on physical
media, this release provides equivalent access to the corresponding source
from a network server, as contemplated by GPL-3.0 section 6 as incorporated by
LGPL-3.0. The Qt Project's own servers are outside our control, so these
copies are retained and served by us for as long as we distribute the matching
binary.

Directions pointing here also appear in `LGPL_COMPLIANCE.txt` inside the
installed application folder and on the product download page, so they sit
next to the object code rather than only inside the installer.

## Retention

This release is retained for as long as AB Event Decor LLC distributes any
build of The Ultimate Balloon Studio linked against Qt 6.9.3, and is not
removed when newer Qt versions ship. Later Qt versions get their own release.

## If an asset will not download

Email **support@abeventdecor.com** with the subject `LGPL corresponding source
request`, naming the product version and which archives you need. Postal
requests, including requests for source on physical media:

```
AB Event Decor LLC
45 Clover Drive
Essex, VT 05452
United States
```
