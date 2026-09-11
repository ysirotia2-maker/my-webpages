# My Webpages (Jekyll site)

This repository hosts a Jekyll-based personal website with a blog, a products section for digital tools, and a small set of Python analysis tools included under tools/.

Quick publishing notes
1. Push changes to GitHub. The repository contains a GitHub Actions workflow (.github/workflows/deploy.yml) that builds the site with Bundler/Jekyll and publishes the generated _site to GitHub Pages.
2. A CNAME for the custom domain `yogeshsirotia.in` is present; configure your DNS provider accordingly.

Content locations
- Blog posts: _posts/*.md (use the standard Jekyll filename format YEAR-MONTH-DAY-title.md)
- Products: files under products/ contain product pages (each page may include an in-browser runner).

Interactive tools (in-browser)
------------------------------
Two Python-based tools were converted from notebooks and added as CLI scripts under tools/:

- tools/day_candle_identifier.py — analyze a one-row-per-symbol CSV snapshot and group symbols by candle type.
- tools/candle_date_identifier.py — analyze historical OHLC CSV and list dates matching candle types.

These tools are now runnable directly on their product pages using Pyodide (Python in the browser). Visit the product pages on the live site and use the file input to upload a CSV; the page will load Pyodide from CDN and run the analysis client-side (no server-side execution).

CSV formats
- Day snapshot (day-candle-identifier): name,open,high,low,close,volume,turnover
- Historical (candle-date-identifier): date,open,high,low,close,volume,turnover

Local CLI usage
----------------
If you prefer to run locally (Python 3.8+):

python tools/day_candle_identifier.py path/to/today_snapshot.csv
python tools/candle_date_identifier.py path/to/historical_data.csv

Both scripts print a JSON-like mapping of candle type -> list of symbols/dates and can be integrated into your own workflows.

Developer notes
- The site uses a Gemfile to pin Jekyll and the theme so CI (GitHub Actions) can build reliably.
- The deploy workflow expects repository secrets for publishing if you use a personal access token. Check .github/workflows/deploy.yml for details.

If you want me to: wire server-side runners, add authenticated uploads, or change the CSV schemas, tell me which option you prefer.
