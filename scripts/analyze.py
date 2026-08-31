#!/usr/bin/env python3
"""analyze.py — vision cadangan berbasis pixel (HSV):
   ./analyze.py FILE [FILE...]"""
import sys
from PIL import Image
from collections import Counter

def hsv_of(p):
    r, g, b = (v/255 for v in p)
    mx, mn = max(r, g, b), min(r, g, b)
    d = mx - mn
    if d < 0.08:
        v = mx
        if v < 0.12: return "hitam"
        if v < 0.42: return "abu" if v < 0.85 else "terang"
        if v < 0.80: return "abu"
        return "putih"
    if mx == r: h = ((g-b)/d) % 6
    elif mx == g: h = (b-r)/d + 2
    else: h = (r-g)/d + 4
    h = int(h*60)
    s = d/mx
    if h < 12 or h >= 350: return "MERAH"
    if h < 40: return "ORANYE"
    if h < 68: return "KUNING"
    if h < 150: return "HIJAU"
    if h < 195: return "BIRU-TOSKA"
    if h < 260: return "BIRU"
    if h < 300: return "UNGU"
    return "MAGENTA"

def key(p):
    return tuple(v // 48 * 48 for v in p)

for path in sys.argv[1:]:
    im = Image.open(path).convert('RGB')
    w, h = im.size
    ss = im.resize((260, int(260*h/w)))
    px = list(ss.getdata())
    n = len(px)

    groups = Counter(hsv_of(p) for p in px)
    print(f"== {path.split('/')[-1]}  {im.size} ==")
    print("   komposisi warna (% luas):")
    for k in ("hitam","abu","putih","MERAH","ORANYE","KUNING","HIJAU","BIRU-TOSKA","BIRU","UNGU","MAGENTA"):
        v = groups.get(k, 0)
        if v: print(f"     {k:11s} {100*v/n:5.1f}%")

    # warna mencolok (saturasi tinggi & bukan netral)
    flashy = Counter(hsv_of(p) for p in px
                     if hsv_of(p) not in ("hitam","abu","putih"))
    if flashy:
        top = flashy.most_common(3)
        print(f"   warna paling mencolok: {', '.join(f'{k} {100*v/n:.0f}%' for k,v in top)}")

    # lokasi warna mencolok per kuadran
    regime = {"kiri-atas": (0,0,w//2,h//2), "kanan-atas":(w//2,0,w,h//2),
              "kiri-bawah":(0,h//2,w//2,h), "kanan-bawah":(w//2,h//2,w,h)}
    loc = Counter()
    w2, h2 = w//2, h//2
    for y in range(h2):
        for x in range(w2):
            pass
    # sample via resized only, not per-pixel; do coarse zone scan
    small = im.resize((100, int(100*h/w)))
    sp = small.load()
    for q, (x0,y0,x1,y1) in regime.items():
        cc = Counter()
        xs0, ys0 = int(x0/ w*100), int(y0/h*small.size[1])
        for yy in range(ys0, int(y1/h*small.size[1]), 2):
            for xx in range(xs0, int(x1/w*100), 2):
                hh = hsv_of(sp[xx, yy])
                if hh not in ("hitam","abu","putih"):
                    cc[hh] += 1
        if cc:
            k, v = cc.most_common(1)[0]
            if v >= 3: loc[f"{k} di {q}"] = v
    if loc:
        print("   lokasi warna mencolok:")
        for k, v in loc.most_common(6):
            print(f"     {k}")
    print()