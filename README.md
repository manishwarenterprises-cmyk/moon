# Hona Tha Pyaar — Lyric Video Site

A single-page animated lyric video for the song **"Hona Tha Pyaar"** (`Hona Tha Pyaar.mp3`).

8 lyric scenes — each with a cute transparent chibi/couple illustration (Pixabay royalty-free) — synchronized typewriter lyrics, floating heart particles, butterflies, and a custom minimal audio player. No external JS/CSS libraries; everything is vanilla in one `index.html`.

---

## Quick Start

```
start.bat            # starts the server on port 8765
stop.bat             # stops it
```

Or manually: `powershell -NoProfile -ExecutionPolicy Bypass -File serve.ps1`

Open **http://localhost:8765** — after any file change press **Ctrl+F5** (hard refresh; `serve.ps1` sends `no-cache` headers and the page carries cache-control meta tags).

---

## Project Structure

| File | Purpose |
|---|---|
| `index.html` | Entire app — markup, CSS, and the player/lyric/particle JS |
| `scene1.png` … `scene8.png` | Scene images (final, verified) |
| `Hona Tha Pyaar.mp3` | Song audio (42.17 s, END capped at 36 s) |
| `serve.ps1` | HttpListener server, port 8765, serves the project folder, no-cache headers |
| `start.bat` / `stop.bat` | Server convenience scripts |
| `README.md` | This document |

---

## Scene Map (verified 2026-08-14)

| Scene | t (sec) | Lyric | Image |
|---|---|---|---|
| 01 | 0 | Tere dil ke shehar mein | scene1.png — man with gift heart (`love-2768554`) |
| 02 | 4.7 | Ghar mera ho gaya ho gaya | scene2.png — boy + girl composite (user's girl photo keyed to transparent, drawn in front of the boy) |
| 03 | 8.7 | Sapna dekha jo tumne | scene3.png — caricature happy couple (`olenchic-caricature-10101102`) |
| 04 | 12.8 | Woh mera ho gaya ho gaya | scene4.png — couple inside a big red heart (`love-4824378`) |
| 05 | 17.1 | Doobe toh yun | scene5.png — boy sinking head-down, water band + bubbles |
| 06 | 21.3 | Jaise ho paar | scene6.png — kawaii couple (`anime-7260244`) |
| 07 | 27 | Hona tha pyaar (chorus) | scene7.png — couple illustration + red heart (`couple-illustration-10080053`) |
| 08 | 31 | hua mere yaar (chorus) | scene8.png — couple in close embrace, floating hearts (`creativecanvasshop-couple-10392078`) |

Chorus split: scene 07 types **27–31 s**, scene 08 types **31–36 s** (its `textEnd: 36`).

Timings were derived from the actual MP3 using ffmpeg RMS waveform analysis (≈ 4.2 s per phrase; dips at ~4.7 / 8.7 / 12.8 / 17.1 / 21.3 / 25.3 / 29.7 / 33.8 s, outro to 42.17 s), then chorus timings were fine-tuned by ear ("Hona tha pyaar" 27–31, "hua mere yaar" 31–36).

File fingerprints (byte sizes): scene1=189932, scene2=108518, scene3=1673460, scene4=303961, scene5=162386, scene6=549653, scene7=259453, scene8=285590.

---

## Features

- **Typewriter lyrics in sync with the song** — each line starts empty (only a blinking caret) and characters appear one-by-one as the singer sings them (`.typed` spans, rose glow).
- **Chorus effect** — scenes 07/08 pulse the image and burst hearts (`imgPulse` + heart burst).
- **Background particles (canvas)** — 18 floating hearts + 12 butterflies (7 gliding in the central band, 5 roaming the full screen) with hinged-wing flapping and natural wander steering.
- **Dark theme per scene** — every scene uses a dark gradient; colors rotate across pages: sunset (dark rose), dusk (dark magenta), starry (deep navy), night (indigo), gold (dark plum), rose, violet. Smooth 2.2 s crossfade.
- **Minimal player** — auto-hides while playing, reappears on hover or when paused. Shows play/pause, seek bar, time.
- **Loop** — plays the START→END segment, then resets.

### Keyboard shortcuts

| Key | Action |
|---|---|
| `Space` | Play / pause |
| `←` / `→` | Nudge all remaining scene timings by ±0.5 s (handy for live sync) |
| `[` / `]` | Set loop start / end at the current position (saved in `localStorage htpStart/htpEnd`; the on-screen chips were removed) |

---

## Maintenance

### Replacing a scene image

1. Test the PNG before accepting it (System.Drawing method): corner pixels `A=0` (transparent background), and 0 opaque pixels on all 4 border rows/cols (uncropped). Reject otherwise.
2. `Copy-Item` the verified file as `sceneN.png` in the project root.
3. Verify after serving: HTTP 200 + expected byte size.
4. Hard refresh (Ctrl+F5).

If inserting a new scene in the middle of the sequence, rename existing files in **descending** order (scene7→8, 6→7, …) to avoid overwrites.

### Stopping the server safely (CRITICAL)

```powershell
$conn = Get-NetTCPConnection -LocalPort 8765 -State Listen -ErrorAction SilentlyContinue
if ($conn) { $conn.OwningProcess | Select-Object -Unique | Where-Object { $_ -ne $PID } | ForEach-Object { Stop-Process -Id $_ -Force } }
```

Never kill by matching the process command line against `serve.ps1` — the current shell's own command line contains that string and it kills itself.

### Validating the script block

The `<script>` block of `index.html` is extracted and checked with `node --check` before serving.

---

## Verified image pool (references, not stored in repo)

Transparent + uncropped spares: `illustrator-1908271` (xmas girl), `anime-girl-7096666` (night city girl), `girl-8391297` (chibi pink hijab), `couple-9753163`, `hsaart-couple-10115877` (scene-8 spares), `couple-1456936` (white bg, needs keying).

CDN pattern: `https://cdn.pixabay.com/photo/<year>/<month>/<day>/<hour>/<slug>_1280.png` — e.g. `woman-7749359_1280.png`.

Rejected/dead: 404 now — `ai-generated-9541441`, `ai-generated-9443349`, `ai-generated-8705657`, `ai-generated-8069255`, `manga-boy-and-girl-eyes-6545036`, `girl-8435339`, `anime-8052801`, `couple-hug-307924`, `girl-dance-34082`. Cropped — `girl-1237350`, `bunny-5860131`, `anime-9866755`, `hearts-9352570`, `couple-151694`, `love-1227863`, `chibi-1454333`, `girl-8335519`. Opaque — `ai-generated-9424586`, `ai-generated-8425256`, `girl-7196709`. Rejected by eye — `chibi-style-7018740`, `chibi-style-7018753`, `cute-chibi-girl-9866939`.

---

## Notes

- Song END is fixed at **36 s** (`Math.min(36, audio.duration)` on `loadedmetadata`); the old localStorage `htpEnd` value is no longer read.
- UI elements removed by request (2026-08-14): scene-number labels, "♥ aankhon se chalta hai ye geet ♥" header, "BOL · 2011" badge, portion chips row + hint, `preview.html`, and all `cand\` source images (scene rebuild sources no longer exist in the repo; current `sceneN.png` files are final).
- User communication is in Bengali — replies in Banglish, kept short.