# Site scaffold

This repository contains a minimal Jekyll site configured for GitHub Pages. It includes a blog and a products page for selling digital goods.

To publish:
1. Push this repo to GitHub.
2. In GitHub repository settings > Pages, enable GitHub Pages (use the main branch / root or gh-pages branch as desired).
3. A CNAME file has been added for the custom domain `yogeshsirotia.in`. Configure your domain's DNS to point to GitHub Pages (A records to GitHub IPs or use the recommended ALIAS/ANAME/CNAME per your DNS provider).

Editing content:
- Blog posts: add Markdown files to `_posts/` with the format `YEAR-MONTH-DAY-title.md`.
- Products: edit `products.md` and replace the placeholder links with Gumroad or Stripe Checkout links.

Payment provider:
- Recommended quick path: create Gumroad products and use their direct product URLs as the Buy links.
- For Stripe, create hosted Checkout sessions and use the session URLs.

Next steps I can do on request:
- Wire up Stripe Checkout integration instead of static links.
- Add site analytics or comments.
- Apply a visual theme or custom branding.

Local tools
-------------
Three small placeholder Python tools were added under the `tools/` directory:

- `tools/candle_identifier.py`  -- accepts `--data` or stdin and prints detected (mock) candle patterns.
- `tools/pattern_identifier.py` -- accepts `--symbols` or `--data` and prints placeholder pattern results.
- `tools/stock_identifier.py`   -- accepts `--symbol` and optional `--range` to print a backtest summary placeholder.

Run examples (ensure you have Python 3 installed):

```
python tools/candle_identifier.py --data "hammer doji"
python tools/pattern_identifier.py --symbols "AAPL,MSFT"
python tools/stock_identifier.py --symbol AAPL --range "2024-01-01 to 2024-07-31"
```
