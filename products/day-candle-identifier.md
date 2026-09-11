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

<hr />
<h2>Try it in your browser</h2>
<p>Upload a CSV with columns: <code>name,open,high,low,close,volume,turnover</code></p>
<input id="dc-upload" type="file" accept=".csv" />
<button id="dc-run" class="btn">Run</button>
<div id="dc-status" class="muted" style="margin-top:0.5rem"></div>
<div id="dc-results" style="margin-top:1rem;overflow:auto"></div>

<script>
// In-browser runner using Pyodide
async function initDayRunner(){
  const runBtn = document.getElementById('dc-run');
  const statusEl = document.getElementById('dc-status');
  const resultsEl = document.getElementById('dc-results');
  let pyodide = null;
  async function ensurePy(){
	if(pyodide) return pyodide;
	statusEl.textContent = 'Loading Python runtime (pyodide)...';
	pyodide = await loadPyodide({indexURL: 'https://cdn.jsdelivr.net/pyodide/v0.23.4/full/'});
	statusEl.textContent = 'Ready';
	return pyodide;
  }

  runBtn.addEventListener('click', async function(){
	const f = document.getElementById('dc-upload').files[0];
	if(!f){ alert('Select a CSV file first'); return; }
	statusEl.textContent = 'Reading file...';
	const text = await f.text();
	statusEl.textContent = 'Preparing Python...';
	await ensurePy();
	try{
	  pyodide.globals.set('csv_text', text);
	  const pyCode = `
import io, csv, json
from collections import defaultdict
f = io.StringIO(csv_text)
reader = csv.reader(f)
header = next(reader, None)
result = defaultdict(list)
for r in reader:
	if not r or len(r) < 5:
		continue
	name = r[0]
	try:
		open_p = float(r[1]); high_p = float(r[2]); low_p = float(r[3]); close_p = float(r[4])
	except Exception:
		continue
	max_change = high_p - low_p
	body_size = abs(close_p - open_p)
	close_height = close_p - low_p
	if max_change == 0:
		ctype = 'undefined'
	elif body_size < 0.1 * max_change:
		if close_height < 0.3 * max_change:
			ctype = 'shooting star'
		elif close_height > 0.7 * max_change:
			ctype = 'hammer candle'
		else:
			ctype = 'doji candle'
	elif body_size > 0.9 * max_change:
		if close_p > open_p:
			ctype = 'bullish maribozu'
		else:
			ctype = 'bearish maribozu'
	else:
		ctype = 'undefined'
	result[ctype].append(name)
json.dumps(result)
`;
	  statusEl.textContent = 'Analyzing...';
	  const jsonStr = await pyodide.runPythonAsync(pyCode);
	  const obj = JSON.parse(jsonStr);
	  // render table: columns are keys
	  const keys = Object.keys(obj);
	  if(keys.length === 0){ resultsEl.innerHTML = '<p>No results</p>'; statusEl.textContent='Done'; return; }
	  // build rows by extending shorter lists
	  const maxLen = Math.max(...keys.map(k=>obj[k].length));
	  let html = '<table class="products-list" style="width:100%;border-collapse:collapse"><thead><tr>';
	  for(const k of keys) html += '<th style="text-align:left;padding:6px;border-bottom:1px solid #ddd">'+k+'</th>';
	  html += '</tr></thead><tbody>';
	  for(let i=0;i<maxLen;i++){
		html += '<tr>';
		for(const k of keys){ html += '<td style="padding:6px;border-bottom:1px solid #eee">'+(obj[k][i]||'')+'</td>'; }
		html += '</tr>';
	  }
	  html += '</tbody></table>';
	  resultsEl.innerHTML = html;
	  statusEl.textContent = 'Done';
	}catch(err){ statusEl.textContent = 'Error: '+err; console.error(err); }
  });
}

if(typeof loadPyodide === 'undefined'){
  const s = document.createElement('script');
  s.src = 'https://cdn.jsdelivr.net/pyodide/v0.23.4/full/pyodide.js';
  s.onload = initDayRunner; document.head.appendChild(s);
} else { initDayRunner(); }
</script>
