---
layout: default
title: Candle Date Identifier
permalink: /products/candle-date-identifier/
---

<h1>Candle Date Identifier</h1>
<p>A tool that analyzes multi-year series CSV files (date,open,high,low,close,volume,turnover) and returns dates where selected candle types appear. The online runner will accept an uploaded CSV and produce a table with candle types as column headers and the dates listed underneath.</p>

<blockquote class="hero-quote">"Sometimes the simplest things points to the biggest changes"</blockquote>

<p>Output lists candle types and matching dates for the provided CSV.</p>

<hr />
<h2>Try it in your browser</h2>
<p>Upload a CSV with columns: <code>date,open,high,low,close,volume,turnover</code></p>
<input id="cd-upload" type="file" accept=".csv" />
<button id="cd-run" class="btn">Run</button>
<div id="cd-status" class="muted" style="margin-top:0.5rem"></div>
<div id="cd-results" style="margin-top:1rem;overflow:auto"></div>

<div style="margin-top:0.5rem">
  <button id="cd-download" class="btn">Download CSV template</button>
  <label style="margin-left:1rem">or paste CSV below:</label>
  <br />
  <textarea id="cd-paste" rows="5" style="width:100%;margin-top:0.5rem" placeholder="date,open,high,low,close,volume,turnover\n"></textarea>
</div>

<script>
// Refactored runner: load the actual tool source into pyodide and run a small wrapper
async function initDateRunner(){
  const runBtn = document.getElementById('cd-run');
  const statusEl = document.getElementById('cd-status');
  const resultsEl = document.getElementById('cd-results');
  const downloadBtn = document.getElementById('cd-download');
  const pasteArea = document.getElementById('cd-paste');
  let pyodide = null;

  async function ensurePy(){
	if(pyodide) return pyodide;
	statusEl.textContent = 'Loading Python runtime (pyodide)...';
	pyodide = await loadPyodide({indexURL: 'https://cdn.jsdelivr.net/pyodide/v0.23.4/full/'});
	statusEl.textContent = 'Ready';
	return pyodide;
  }

  downloadBtn.addEventListener('click', function(){
	const header = 'date,open,high,low,close,volume,turnover\n';
	const example = '2026-08-20,100,110,98,108,100000,1000000\n';
	const blob = new Blob([header+example], {type: 'text/csv'});
	const url = URL.createObjectURL(blob);
	const a = document.createElement('a');
	a.href = url; a.download = 'historical-template.csv'; document.body.appendChild(a); a.click(); a.remove();
	URL.revokeObjectURL(url);
  });

  runBtn.addEventListener('click', async function(){
	const f = document.getElementById('cd-upload').files[0];
	let text = '';
	if(f){
	  statusEl.textContent = 'Reading file...';
	  text = await f.text();
	} else if(pasteArea.value && pasteArea.value.trim().length>0){
	  text = pasteArea.value.trim();
	} else { alert('Select a CSV file or paste CSV into the box'); return; }

	statusEl.textContent = 'Previewing...';
	const preview = text.split('\n').slice(0,6).join('\n');
	resultsEl.innerHTML = '<pre style="white-space:pre-wrap">' + preview + '</pre>';

	await ensurePy();

	try{
	  statusEl.textContent = 'Loading tool into Python...';
	  const toolResp = await fetch('/tools/candle_date_identifier.py');
	  const toolSource = await toolResp.text();
	  pyodide.runPython(toolSource);
	  const wrapper = `import io,csv,json
from collections import defaultdict
def analyze_text(csv_text):
	f = io.StringIO(csv_text)
	reader = csv.reader(f)
	header = next(reader, None)
	result = defaultdict(list)
	for r in reader:
		if not r or len(r) < 5:
			continue
		date = r[0]
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
		result[ctype].append(date)
	return json.dumps(result)
`;
	  pyodide.runPython(wrapper);
	  pyodide.globals.set('csv_text', text);
	  statusEl.textContent = 'Analyzing...';
	  const jsonStr = await pyodide.runPythonAsync('analyze_text(csv_text)');
	  const obj = JSON.parse(jsonStr);
	  const keys = Object.keys(obj);
	  if(keys.length === 0){ resultsEl.innerHTML = '<p>No results</p>'; statusEl.textContent='Done'; return; }
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
  s.onload = initDateRunner; document.head.appendChild(s);
} else { initDateRunner(); }
</script>
