---
layout: default
title: Pattern Identifier
permalink: /products/pattern-identifier/
---

<h1>Pattern Identifier</h1>
<p>A little complex candle pattern identifier to determine where your patterns are seen today.</p>

<blockquote class="hero-quote">"Everything happens in patterns, identifying the right one can change you forever"</blockquote>

<form id="pattern-form">
  <label for="pattern-input">Paste market data or symbols (comma-separated):</label><br>
  <input id="pattern-input" name="symbols" type="text" size="60" placeholder="AAPL,MSFT,GOOG" />
  <br><small>Or paste OHLC lines in the textarea below.</small><br>
  <textarea id="pattern-text" name="data" rows="6" cols="60" placeholder="Optional: paste OHLC lines..."></textarea>
  <br>
  <button type="button" onclick="runLocal()" class="btn">Run locally</button>
  <p class="muted">Use <code>tools/pattern_identifier.py</code> locally. It accepts --symbols or --data (stdin).</p>
</form>

<script>
function runLocal(){
  const s = document.getElementById('pattern-input').value;
  const d = document.getElementById('pattern-text').value;
  if(!s && !d) { alert('Enter symbols or data'); return; }
  alert('Run locally: python tools/pattern_identifier.py ' + (s? '--symbols "'+s+'"':'') + (d? ' --data "'+d.replace(/"/g,'\\\"')+'"':'') );
}
</script>
