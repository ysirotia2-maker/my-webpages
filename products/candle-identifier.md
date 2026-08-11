---
layout: default
title: Candle Identifier
permalink: /products/candle-identifier/
---

<h1>Candle Identifier</h1>
<p>A very simple tool to identify what candle patterns were formed in the market today.</p>

<blockquote class="hero-quote">"Sometimes the simplest things points to the biggest changes"</blockquote>

<form id="candle-form">
  <label for="candle-input">Paste market data or a short description:</label><br>
  <textarea id="candle-input" name="data" rows="6" cols="60" placeholder="Paste candles or OHLC lines here..."></textarea>
  <br>
  <button type="button" onclick="runLocal()" class="btn">Run locally</button>
  <p class="muted">This page contains an input for local processing. A Python tool is available at <code>tools/candle_identifier.py</code> which accepts input via --data or stdin.</p>
</form>

<script>
function runLocal(){
  const v = document.getElementById('candle-input').value;
  if(!v) { alert('Enter some data to test'); return; }
  alert('This site is static. To process, run: python tools/candle_identifier.py --data "' + v.replace(/"/g,'\\\"') + '"');
}
</script>
