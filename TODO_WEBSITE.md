Website TODO log

This file lists outstanding tasks and notes for the website. Keep items concise and actionable.

Open / Pending
- Verify that /tools/*.py files are published to the site output. If not, add `include: ["tools"]` to _config.yml so Jekyll copies them to _site.
- Improve CSV parsing to support quoted fields and different newline conventions.
- Add server-side runner option (if needed) and secure upload handling.
- Add unit tests for Python tools and a small test CSV suite.
- Add accessibility improvements for forms and tables (labels, ARIA attributes).
- Add analytics (optional) and monitor CountAPI reliability; consider local fallback storage for view counts.
- Add explicit error messages and validation on product pages for missing/invalid CSV columns.

Completed recently
- Added Pyodide-based in-browser runners for day-candle-identifier and candle-date-identifier.
- Refactored product pages to load canonical tools/*.py into Pyodide.
- Added CSV template download and paste-area preview for easy uploads.
- Updated README to describe current site and in-browser tools.
- Removed placeholder wording from product pages and products listing.

Notes
- Pyodide is loaded from CDN (jsdelivr). Initial load may be slow on first visit.
- If tools are not reachable under /tools/ on the published site, change the fetch path or include the folder in Jekyll's include list.

