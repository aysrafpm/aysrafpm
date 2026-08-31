#!/usr/bin/env python3
import socket, sys, time, os, subprocess

def screendump(out):
    import socket
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.settimeout(4)
    s.connect('/data/data/com.termux/files/home/windows10/monitor.sock')
    s.recv(4096)
    s.settimeout(15)
    s.send(b'screendump %s\n' % out.encode())
    time.sleep(4)
    s.close()

def main():
    args = sys.argv[1:]
    path = None
    if args and args[0].startswith('-f'):
        path = args[1]; args = args[2:]
    focus = args[0] if args else 'full'

    if path is None:
        screendump('/data/data/com.termux/files/home/win-emulator/raw.ppm')
        path = '/data/data/com.termux/files/home/win-emulator/raw.ppm'

    from PIL import Image, ImageOps, ImageFilter

    img = Image.open(path).convert('RGB')
    w, h = img.size

    # region crop
    if focus == 'center':
        box = (int(w*0.15), int(h*0.25), int(w*0.85), int(h*0.75))
        img = img.crop(box)
    elif focus == 'top':
        box = (0, 0, w, int(h*0.30))
        img = img.crop(box)
    elif focus == 'bottom':
        box = (0, int(h*0.60), w, h)
        img = img.crop(box)
    w, h = img.size

    gray = img.convert('L')
    mean = sum(gray.getdata()) // (w*h)
    bright = 100*mean/255

    # HI-RES output
    big = img.resize((w*4, h*4), Image.LANCZOS)
    big = big.filter(ImageFilter.UnsharpMask(radius=2, percent=180, threshold=2))
    big.save('/data/data/com.termux/files/home/win-emulator/foto_hires.png')

    # OCR pass 1: enhanced grayscale
    g = gray.resize((w*3, h*3), Image.LANCZOS)
    g = ImageOps.autocontrast(g)
    g = g.filter(ImageFilter.UnsharpMask(radius=2, percent=140, threshold=3))
    g.save('/data/data/com.termux/files/home/win-emulator/ocr_a.png')

    # OCR pass 2: binarized (Otsu)
    hist = g.histogram()
    total = sum(hist); su = 0; sw = 0
    best = (0, 0)
    for t in range(256):
        wb = sum(hist[:t]); ub = sum(i*hist[i] for i in range(t))
        wf = total - wb; uf = su - ub
        if wb == 0 or wf == 0: continue
        mb, mf = ub/wb, uf/wf
        var = wb*wf*(mb-mf)**2
        if var > best[0]: best = (var, t)
    th = best[1] if best[1] else 128
    bw = g.point(lambda p: 255 if p > th else 0)
    bw.save('/data/data/com.termux/files/home/win-emulator/ocr_b.png')

    # keep shared copy for the user
    import shutil
    try:
        shutil.copy(big, '/data/data/com.termux/files/home/win-emulator/lihat_perbesar.png')
    except Exception:
        pass

    results = []
    for tag, f in (('psm6', 'ocr_a.png'), ('psm6-bin', 'ocr_b.png'), ('psm11-bin', 'ocr_b.png'), ('psm3', 'ocr_a.png')):
        psm = tag.split('-')[0][3:]
        cmd = ['tesseract', f, 'stdout', '--psm', psm, '-c', 'preserve_interword_spaces=1']
        try:
            out = subprocess.run(cmd, capture_output=True, text=True, timeout=60).stdout
            lines = [l.strip() for l in out.splitlines() if l.strip()]
            if lines:
                results.append((tag, lines))
        except Exception:
            pass

    print(f"### ukuran={path.split('/')[-1]} {w}x{h} bright={bright:.1f}% focus={focus}")
    seen = set()
    for tag, lines in results:
        joined = [l for l in lines if l not in seen]
        if not joined: continue
        print(f"\n>> OCR ({tag}):")
        for l in joined[:14]:
            print('  ', l)
            seen.add(l)

if __name__ == '__main__':
    main()