# 📚 Porbi

> Read Anything, Anywhere.

Porbi is a modern, offline-first document reader built with Flutter, designed for readers, students, developers, researchers, and knowledge workers who want a clean and distraction-free reading experience.

Open Markdown files, EPUB books, plain text documents, and HTML content directly from your device, cloud storage providers, or Android's "Open With" menu.

Built with performance, privacy, and simplicity in mind.

---

## ✨ Features

### 📖 Multi-Format Reader

Supported formats:

| Format               | Support |
| -------------------- | ------- |
| TXT                  | ✅       |
| Markdown (.md)       | ✅       |
| Markdown (.markdown) | ✅       |
| EPUB                 | ✅       |
| HTML                 | ✅       |
| HTM                  | ✅       |

Planned:

* PDF
* MOBI
* FB2
* DOCX
* RTF

---

## 🚀 Android File Integration

Porbi integrates directly with Android's file system.

Open files from:

* Files App
* Downloads
* Google Drive
* OneDrive
* Dropbox
* WhatsApp
* Telegram
* Email Attachments
* Third-party File Managers

When a supported file is clicked, Android can show:

```text
Open With

✓ Porbi
✓ Other Reader Apps
```

Porbi supports:

* ACTION_VIEW
* ACTION_SEND
* Content URIs
* Document URIs
* Deep Linking

---

## 📚 Library Management

Create your own personal digital library.

Features:

* Import documents
* Import books
* Recent files
* Continue reading
* Reading history
* Favorites
* Collections
* Tags
* Categories

Sorting:

* Name
* Last Opened
* Import Date
* Reading Progress

View Modes:

* Grid View
* List View

---

## 📝 Markdown Reader

Full Markdown rendering support.

Supports:

* Headings
* Tables
* Lists
* Checklists
* Blockquotes
* Horizontal Rules
* Images
* Links
* Inline Code
* Code Blocks
* Syntax Highlighting

Perfect for:

* Documentation
* Technical Notes
* Knowledge Bases
* Project Readmes
* Developer Wikis

---

## 📘 EPUB Reader

Advanced EPUB reader with support for:

* EPUB 2
* EPUB 3
* Cover Extraction
* Metadata Parsing
* Table Of Contents
* Chapter Navigation
* Embedded Images
* Internal Links
* Reading Progress

Automatically remembers:

* Current chapter
* Scroll position
* Last opened page

---

## 🌐 HTML Reader

Read local HTML files without requiring a browser.

Supports:

* HTML5
* Images
* Tables
* Links
* Basic Styling
* Embedded Assets

Useful for:

* Exported Documentation
* Offline Manuals
* Technical Guides
* Knowledge Archives

---

## 🔖 Bookmarks

Save important locations.

Features:

* Add Bookmark
* Rename Bookmark
* Delete Bookmark
* Jump To Bookmark
* Organize Bookmarks

Bookmarks are stored locally.

No cloud dependency required.

---

## ✏️ Highlights

Highlight important text.

Features:

* Multi-color highlights
* Persistent storage
* Fast retrieval
* Searchable highlights

Ideal for:

* Study Notes
* Research
* Documentation Review

---

## 📓 Notes

Attach notes to selected text.

Features:

* Rich text notes
* Timestamped notes
* Linked to reading position
* Search notes
* Export notes

---

## 🔍 Search

Powerful search capabilities.

### In-Book Search

Search within:

* EPUB chapters
* Markdown files
* TXT files
* HTML documents

Features:

* Highlight matches
* Jump between matches
* Case-sensitive search
* Whole-word search

### Library Search

Search across:

* Book titles
* File names
* Notes
* Bookmarks

---

## 🎨 Reading Experience

Customize the reader to your preference.

Themes:

* Light
* Dark
* Sepia
* OLED Black

Reader Controls:

* Font Size
* Font Family
* Line Height
* Margins
* Text Alignment
* Screen Brightness

Reading Modes:

* Scroll
* Paginated
* Fullscreen

---

## 💾 Offline First

Porbi works completely offline.

No account required.

No internet connection required.

Your files remain on your device.

Benefits:

* Faster loading
* Better privacy
* No subscriptions required
* No cloud dependency

---

## 🔒 Privacy First

Porbi is designed around privacy.

We do not:

* Track reading habits
* Collect personal data
* Upload documents
* Scan files
* Show advertisements

Your library remains yours.

---

## ⚡ Performance

Optimized for large files.

Supports:

* Large Markdown documents
* Large EPUB books
* Large HTML manuals
* Thousands of library items

Techniques:

* Lazy Loading
* Virtualized Lists
* Incremental Parsing
* Efficient Database Queries

---

## 🗄 Architecture

Porbi follows Clean Architecture principles.

```text
Presentation Layer
│
├── Screens
├── Widgets
└── Riverpod Providers
│
Domain Layer
│
├── Models
├── Entities
└── Use Cases
│
Data Layer
│
├── Repositories
├── Drift Database
└── File Services
```

---

## 🏗 Tech Stack

### Framework

* Flutter
* Dart

### State Management

* Riverpod

### Navigation

* GoRouter

### Database

* Drift (SQLite)

### File Handling

* file_picker

### EPUB

* epubx

### Markdown

* flutter_markdown

### HTML

* flutter_html

### Archive Handling

* archive

### Permissions

* permission_handler

---

## 📁 Project Structure

```text
lib/

core/
services/
storage/
theme/
router/
utils/

features/

library/
reader/
bookmarks/
notes/
search/
settings/

models/
providers/

main.dart
```

---

## 🔧 Android Requirements

Minimum SDK:

```text
24
```

Target SDK:

```text
Latest Stable Android SDK
```

Supported Android Versions:

* Android 7.0+
* Android 8
* Android 9
* Android 10
* Android 11
* Android 12
* Android 13
* Android 14
* Android 15+

---

## 📱 Permissions

Porbi minimizes permission usage.

Required:

| Permission         | Purpose                    |
| ------------------ | -------------------------- |
| POST_NOTIFICATIONS | Optional reading reminders |
| INTERNET           | Future optional features   |

Storage access uses Android Storage Access Framework (SAF).

Porbi does NOT require:

* MANAGE_EXTERNAL_STORAGE
* Full Device Storage Access

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/iamPrashanta/porbi-apk
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Build Release APK (Fat APK):

```bash
flutter build apk --release
```

Build Smaller Optimized APKs (Split per Architecture):

```bash
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/app/outputs/symbols
```
> **Note:** This significantly reduces the APK size by generating separate APKs for each architecture (arm64, armeabi, etc.) instead of bundling them all together. It also obfuscates the Dart code.

Build App Bundle (For Google Play):

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

---

## 🧪 Development Quality Gates

Before every release:

```bash
flutter analyze
flutter test
flutter build apk --release
```


---

## 🛣 Roadmap

### Version 1

* TXT Reader
* Markdown Reader
* EPUB Reader
* HTML Reader
* Android File Association

### Version 2

* PDF Reader
* Highlights
* Notes
* Collections

### Version 3

* Reading Statistics
* Export Highlights
* Advanced Search

### Version 4

* Text To Speech
* AI Summaries
* AI Explanations
* Smart Reading Assistant

---

## 🤝 Contributing

Contributions are welcome.

Please open an issue or submit a pull request.

---

## 📄 License

MIT License

---

## ❤️ Built by Prashanta

Porbi is built for readers, students, developers, researchers, and curious minds who believe knowledge should always be accessible, portable, and private.
