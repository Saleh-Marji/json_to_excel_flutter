# JSON to Excel

A desktop app that turns nested JSON into a spreadsheet. Pick a file, choose which fields become columns, then export Excel (`.xlsx`) or CSV.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)](#build-from-source)

JSON lists, objects, and mixed types are common in APIs and logs. This app unions those shapes into one field tree, lets you map leaves to named columns, and expands nested lists into rows — locally, with no upload.

## Features

- **Offline** — files stay on your machine
- **Nested JSON** — objects, arrays of objects, and primitive lists
- **Type-aware columns** — the same key with different types (for example string `id` vs number `id`) can be mapped separately
- **Saved mapping profiles** — reuse column mappings on similar files
- **Excel or CSV** — column order is the order you arrange on the mapping screen
- **Light and dark** — follows the system theme

## How it works

```text
Pick JSON  →  Choose columns  →  Export spreadsheet
```

1. **Pick a JSON file** (object or array). Nested lists are merged into one field tree so you never have to drill into every array item by hand.
2. **Choose columns.** Expand the tree, tap a leaf, and give it an Excel/CSV header. Drag selected columns to set export order.
3. **Export.** Choose `.xlsx` or `.csv`, pick a destination, and run the job. Progress runs off the UI thread.

### Mapping rules

| Situation | Result |
| --- | --- |
| Arrays of objects | Keys from every object are unioned into one schema |
| Nested lists on selected paths | Cartesian-exploded into rows; unused lists are not exploded |
| Missing keys | Empty cell |
| Fully empty rows | Dropped |
| Same key, different types | Sibling fields; a column fills only when the value’s type matches |
| Saved profile on a new file | Only mappings whose key+type path exists as a leaf are applied |

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) 3.x with Dart SDK `^3.10.3`
- A desktop target: Windows 10+, macOS, or Linux

## Run from source

```bash
git clone https://github.com/Saleh-Marji/json_to_excel_flutter.git
cd json_to_excel_flutter
flutter pub get
flutter run -d windows   # or macos / linux
```

```bash
flutter test
flutter analyze
```

## Build from source

```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

Windows output: `build/windows/x64/runner/Release/`

## Windows installer

After a release build, compile the [Inno Setup](https://jrsoftware.org/isinfo.php) 6 script:

```powershell
flutter build windows --release
& "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer\json_to_excel.iss
```

The setup exe is written to `installer/output/JSON-to-Excel-Setup-1.0.0.exe`. Bump `#define MyAppVersion` in [`installer/json_to_excel.iss`](installer/json_to_excel.iss) when you change the version in `pubspec.yaml`.

## Project layout

```text
lib/
  common/                 shared widgets
  constants/              routes, theme, storage keys, l10n helpers
  di/                     GetX dependency registration
  features/conversion/    import → mapping → export
    models/
    repositories/
    services/
    screen_controllers/
    screens/
    widgets/
  l10n/                   ARB strings (`app_en.arb`)
installer/                Inno Setup script
test/                     mirrors `lib/features/...`
```

User-visible copy lives in [`lib/l10n/app_en.arb`](lib/l10n/app_en.arb). After editing it, run `flutter gen-l10n`.

## Contributing

Issues and pull requests are welcome.

1. Fork the repo and create a branch.
2. Keep UI strings in `app_en.arb` (no hardcoded copy).
3. Add or update tests next to the code they cover under `test/`.
4. Run `flutter analyze` and `flutter test` before opening a PR.

This app uses [GetX](https://pub.dev/packages/get) and [`sm_flutter_base`](https://pub.salehmarji.com) (`^2.2.9`). `flutter pub get` needs access to that hosted pub.

## License

[MIT](LICENSE) © 2026 Saleh Marji
