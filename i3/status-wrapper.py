#!/usr/bin/env python3

import json
import re
import subprocess
import sys
from datetime import datetime

import dbus


def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + "\n")
    sys.stdout.flush()


def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()


def get_spotify_metadata():
    try:
        bus = dbus.SessionBus()

        obj = bus.get_object(
            "org.mpris.MediaPlayer2.spotify",
            "/org/mpris/MediaPlayer2"
        )

        interface = dbus.Interface(
            obj,
            "org.freedesktop.DBus.Properties"
        )

        return interface.Get(
            "org.mpris.MediaPlayer2.Player",
            "Metadata"
        )
    except dbus.exceptions.DBusException:
        return None


def get_memory():
    with open("/proc/meminfo") as f:
        meminfo = f.readlines()

    result = {}

    for line in meminfo:
        if "MemTotal" in line:
            match = re.search(r"(\d+)", line)

            if match:
                result["mem_total"] = int(match.group(1))

        elif "MemAvailable" in line:
            match = re.search(r"(\d+)", line)

            if match:
                result["mem_available"] = int(match.group(1))

        elif "SwapTotal" in line:
            match = re.search(r"(\d+)", line)

            if match:
                result["swap_total"] = int(match.group(1))

        elif "SwapFree" in line:
            match = re.search(r"(\d+)", line)

            if match:
                result["swap_free"] = int(match.group(1))

    return result


def get_brightness():
    info = subprocess.check_output(
        ["brightnessctl", "info"]
    ).decode()

    for line in info.splitlines():
        if "Current" in line:
            percent = re.search(r"\((\d+)%\)", line)

            if percent:
                return percent.group(1)

    return 0


def get_sink_state():
    volume_info = subprocess.check_output(
        ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
    ).decode()

    mute_info = subprocess.check_output(
        ["pactl", "get-sink-mute", "@DEFAULT_SINK@"]
    ).decode()

    volume = re.search(r"(\d+)%", volume_info)
    mute = re.search(r"yes", mute_info)

    return {
        "volume": int(volume.group(1)) if volume else 0,
        "mute": bool(mute),
    }


def get_source_state():
    volume_info = subprocess.check_output(
        ["pactl", "get-source-volume", "@DEFAULT_SOURCE@"]
    ).decode()

    mute_info = subprocess.check_output(
        ["pactl", "get-source-mute", "@DEFAULT_SOURCE@"]
    ).decode()

    volume = re.search(r"(\d+)%", volume_info)
    mute = re.search(r"yes", mute_info)

    return {
        "volume": int(volume.group(1)) if volume else 0,
        "mute": bool(mute),
    }


def get_keyboard_layout():
    info = subprocess.check_output(
        ["xset", "-q"]
    ).decode()

    mask = re.search(r"LED mask:\s+(\d+)", info)

    if not mask:
        return "??"

    mask = int(mask.group(1))

    if mask & 0b1000:
        return "US"

    return "PT"


if __name__ == "__main__":
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:
        line, prefix = read_line(), ""

        # ignore comma at start of lines
        if line.startswith(","):
            line, prefix = line[1:], ","

        j = json.loads(line)

        # MEMORY

        memory = get_memory()

        mem_total = memory.get("mem_total", 1)
        mem_available = memory.get("mem_available", 0)
        swap_total = memory.get("swap_total", 1)
        swap_free = memory.get("swap_free", 0)

        j.insert(0, {
            "full_text": " MEM {}% SWAP {}% ".format(
                int(100 * (1 - mem_available / mem_total)),
                int(100 * (1 - swap_free / swap_total)),
            ),
            "name": "memory",
            "color": "#d75f5f" if mem_available / mem_total < 0.1 else "#ffffff",
        })

        # BRIGHTNESS

        brightness = get_brightness()

        j.insert(0, {
            "full_text": " BRI {}% ".format(brightness),
            "name": "brightness",
        })

        # VOLUME

        capture = get_source_state()

        j.insert(0, {
            "full_text": " MIC {}% ".format(capture.get("volume", 0)),
            "name": "mic",
            "color": "#d75f5f" if capture.get("mute", False) else "#ffffff",
        })

        master = get_sink_state()

        j.insert(0, {
            "full_text": " VOL {}% ".format(master.get("volume", 0)),
            "name": "volume",
            "color": "#d75f5f" if master.get("mute", False) else "#ffffff",
        })

        # SPOTIFY

        spotify_metadata = get_spotify_metadata()

        if spotify_metadata:
            spotify_title = spotify_metadata.get("xesam:title")
            spotify_artist = spotify_metadata.get("xesam:artist")[0]

            j.insert(0, {
                "full_text": " <b>{}</b>  {} ".format(
                    spotify_title, spotify_artist,
                ),
                "name": "spotify",
                "markup": "pango",
            })

        # TIME

        now = datetime.now().strftime("%a %d %b %H:%M")

        j.append({
            "full_text": " {} ".format(now),
            "name": "time",
            "markup": "pango",
        })

        # KEYBOARD LAYOUT

        keyboard_layout = get_keyboard_layout()

        j.append({
            "full_text": " {} ".format(keyboard_layout),
            "name": "keyboard",
        })

        # and echo back new encoded json
        print_line(prefix+json.dumps(j))
