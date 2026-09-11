---
layout: default
title: Day Candle Identifier
permalink: /products/day-candle-identifier/
---

<h1>Day Candle Identifier</h1>
<p>A tool that analyzes a single-day stock snapshot CSV (name,open,high,low,close,volume,turnover) and classifies candle types for each symbol. The online runner accepts an uploaded CSV and returns a table with candle types as column headers and the matching symbols listed below.</p>

<blockquote class="hero-quote">"Everything is easier with tools, here are some to ease your work"</blockquote>

<p><strong>Will be available soon.</strong> You can run this locally using <code>tools/day_candle_identifier.py</code>:</p>
<pre><code>python tools/day_candle_identifier.py path/to/today_snapshot.csv</code></pre>

<p>Output will list candle types and matching symbols. When the online runner is available you'll be able to upload a CSV and see a formatted table.</p>
