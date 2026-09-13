#!/usr/bin/env python3
"""Playerctl-backed waybar media module. Usage: mediaplayer.py {prev,toggle,next,title}"""

import json
import select
import subprocess
import sys
import time

WIDTH = 20
ICON_PREV = "󰒮"  #
ICON_NEXT = "󰒭"  #
ICON_PLAY = ""  #
ICON_PAUSE = ""  #
STOP_DELAY = 5 # seconds


def emit(payload):
    print(json.dumps(payload), flush=True)


def empty():
    emit({"text": ""})


def render(role, status, title, artist):
    playing = status == "Playing"
    css_class = "playing" if playing else "paused"

    if role == "prev":
        emit({"text": ICON_PREV, "class": css_class})
    elif role == "next":
        emit({"text": ICON_NEXT, "class": css_class})
    elif role == "toggle":
        emit({"text": ICON_PAUSE if playing else ICON_PLAY, "class": css_class})
    elif role == "title":
        text = f"{artist} — {title}" if artist else title
        emit({"text": text, "tooltip": text, "class": css_class})


def marquee_frames(title):
    if len(title) <= WIDTH:
        while True:
            yield title
    pad = title + "   •   "
    offset = 0
    while True:
        yield (pad + pad)[offset:offset + WIDTH]
        offset = (offset + 1) % len(pad)


def run(role):
    proc = None
    frames = None
    last_title = None
    last_status = None
    last_artist = None
    query_count = 0

    while True:
        if proc is None or proc.poll() is not None:
            empty()
            proc = subprocess.Popen(
                ["playerctl", "-F", "--format", "{{status}}⟡{{title}}⟡{{artist}}", "metadata"],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True,
                bufsize=1,
            )
            frames = None
            last_title = None
            time.sleep(1)
            continue

        timeout = 0.3 if role == "title" else None
        ready, _, _ = select.select([proc.stdout], [], [], timeout)

        if ready:
            line = proc.stdout.readline()
            if not line:
                proc.wait()
                proc = None
                continue
            parts = line.rstrip("\n").split("⟡", 2)
            if len(parts) != 3 or not parts[0]:
                # Invalid format means a change in state.
                # Two cases - 
                # Player has been destroyed.
                # Or track is transitioning.
                if query_count > 2:
                    empty()
                    frames = None
                    last_title = None
                query_count += 1
                continue
            else:
                query_count = 0
            status, title, artist = parts
            last_status, last_artist = status, artist
            if role == "title":
                if title != last_title:
                    last_title = title
                    frames = marquee_frames(title)
                render(role, status, next(frames), artist)
            else:
                render(role, status, title, artist)
        elif role == "title" and frames is not None:
            render(role, last_status, next(frames), last_artist)


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ("prev", "toggle", "next", "title"):
        print("usage: mediaplayer.py {prev,toggle,next,title}", file=sys.stderr)
        sys.exit(1)
    run(sys.argv[1])


if __name__ == "__main__":
    main()
