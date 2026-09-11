#!/usr/bin/env python3
"""
Candle Date Identifier

Convert of 'candle function.ipynb' into a small CLI module.
Reads a CSV with columns: date,open,high,low,close,volume,turnover
and returns a mapping of candle_type -> list of dates where they appear.
"""
import csv
import sys
from collections import defaultdict

def analyze_file(path):
    rows = []
    with open(path, newline='', encoding='utf-8') as f:
        reader = csv.reader(f)
        header = next(reader, None)
        for r in reader:
            if not r or len(r) < 5:
                continue
            rows.append(r)

    # Expect first columns: date, open, high, low, close, ...
    result = defaultdict(list)
    for r in rows:
        date = r[0]
        try:
            open_p = float(r[1])
            high_p = float(r[2])
            low_p = float(r[3])
            close_p = float(r[4])
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

    return dict(result)


def main():
    if len(sys.argv) < 2:
        print('Usage: python candle_date_identifier.py <csv-file>')
        sys.exit(1)
    path = sys.argv[1]
    res = analyze_file(path)
    # Print as table-like output
    for k, v in res.items():
        print(f"{k}: {len(v)} entries")
        for d in v:
            print(f"  {d}")


if __name__ == '__main__':
    main()
