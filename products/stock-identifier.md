---
layout: default
title: Stock Identifier
permalink: /products/stock-identifier/
---

<h1>Stock Identifier</h1>
<p>Want to know what past holds for a stock you are backtesting, check here.</p>

<blockquote class="hero-quote">"It difficult to look at everything at once, but learning from the past can shape the future."</blockquote>

<form id="stock-form">
  <label for="stock-symbol">Stock symbol:</label>
  <input id="stock-symbol" name="symbol" type="text" placeholder="e.g., AAPL" />
  <br>
  <label for="stock-range">Optional date range (YYYY-MM-DD to YYYY-MM-DD):</label>
  <input id="stock-range" name="range" type="text" placeholder="2024-01-01 to 2024-07-31" size="30" />
  <br>
  <button type="button" onclick="runLocal()" class="btn">Run locally</button>
  <p class="muted">Local tool: <code>tools/stock_identifier.py</code>. It accepts --symbol and optional --range.</p>
</form>

<script>
function runLocal(){
  const sym = document.getElementById('stock-symbol').value;
  const r = document.getElementById('stock-range').value;
  if(!sym){ alert('Enter a stock symbol'); return; }
  alert('Run locally: python tools/stock_identifier.py --symbol "'+sym+'"' + (r? ' --range "'+r+'"':''));
}
</script>
