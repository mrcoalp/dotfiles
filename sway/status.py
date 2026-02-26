#!/usr/bin/env python3

import json
import re
import socket
import subprocess
import sys
import time
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo


def get_player_status():
    try:
        return subprocess.check_output([
            "playerctl", "metadata", "--format",
            "<b>{{ title }}</b> ♪ {{ artist }} :: <i>{{ album }}</i>"
        ]).decode().strip()
    except:
        return None


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


def get_cpu_times():
    try:
        with open("/proc/stat", "r", encoding="utf-8") as f:
            line = f.readline()
    except Exception:
        return None, None

    if not line.startswith("cpu "):
        return None, None

    parts = line.split()
    # parts[0] == 'cpu', then numbers:
    # user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice
    try:
        vals = [int(x) for x in parts[1:]]
    except Exception:
        return None, None

    # idle = idle + iowait if present
    idle = vals[3] + (vals[4] if len(vals) > 4 else 0)
    non_idle = 0
    # user + nice + system + irq + softirq + steal (if present)
    non_idle += vals[0]  # user
    non_idle += vals[1] if len(vals) > 1 else 0  # nice
    non_idle += vals[2] if len(vals) > 2 else 0  # system
    non_idle += vals[5] if len(vals) > 5 else 0  # irq
    non_idle += vals[6] if len(vals) > 6 else 0  # softirq
    non_idle += vals[7] if len(vals) > 7 else 0  # steal

    total = idle + non_idle
    return total, idle


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


def get_ip_address():
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # This doesn't actually send packets, just selects the default interface.
        sock.connect(("1.1.1.1", 80))
        ip = sock.getsockname()[0]
        sock.close()
        return ip
    except Exception:
        # fallback to hostname-based method
        try:
            import socket as _socket
            addrs = _socket.gethostbyname_ex(_socket.gethostname())[2]
            for a in addrs:
                if not a.startswith("127."):
                    return a
        except Exception:
            return ""


def get_battery_status():
    supply = Path("/sys/class/power_supply")

    if not supply.exists():
        return None

    for bat in supply.glob("BAT*"):
        try:
            cap_file = bat / "capacity"
            status_file = bat / "status"

            if cap_file.exists() and status_file.exists():
                percent = int(cap_file.read_text().strip())
                status = status_file.read_text().strip()
                return {"percent": percent, "status": status}
        except Exception:
            continue

    return None


def get_kbd_layout():
    try:
        dump = subprocess.check_output([
            "swaymsg", "-t", "get_inputs"
        ]).decode().strip()

        data = json.loads(dump)

        if not data:
            return None

        for device in data:
            if device.get("type", "") == "keyboard":
                name = device.get("xkb_active_layout_name", None)

                if not name:
                    return None

                if name.startswith("English"):
                    return "EN"

                if name.startswith("Portuguese"):
                    return "PT"

                return name
    except:
        return None

    return None


def build_blocks(cpu_usage=None):
    blocks = []

    # MEDIA

    media_status = get_player_status()

    if media_status:
        blocks.append({
            "full_text": " {} ".format(media_status),
            "name": "media",
            "markup": "pango",
        })

    # VOLUME

    master_volume = get_sink_state()

    blocks.append({
        "full_text": " VOL {}% ".format(master_volume.get("volume", 0)),
        "name": "volume",
        "color": "#d75f5f" if master_volume.get("mute", False) else "#ffffff",
    })

    capture = get_source_state()

    blocks.append({
        "full_text": " MIC {}% ".format(capture.get("volume", 0)),
        "name": "mic",
        "color": "#d75f5f" if capture.get("mute", False) else "#ffffff",
    })

    # BRIGHTNESS

    brightness = get_brightness()

    blocks.append({
        "full_text": " BRI {}% ".format(brightness),
        "name": "brightness",
    })

    # CPU

    if cpu_usage:
        color = "#ffffff"

        if cpu_usage >= 80:
            color = "#d75f5f"
        elif cpu_usage >= 50:
            color = "#d7af5f"

        blocks.append(
            {
                "full_text": " CPU {}% ".format(int(round(cpu_usage))),
                "name": "cpu",
                "color": color,
            }
        )

    # MEMORY

    memory = get_memory()

    mem_total = memory.get("mem_total", 1)
    mem_available = memory.get("mem_available", 0)
    swap_total = memory.get("swap_total", 1)
    swap_free = memory.get("swap_free", 0)

    blocks.append({
        "full_text": " MEM {}% SWAP {}% ".format(
            int(100 * (1 - mem_available / mem_total)),
            int(100 * (1 - swap_free / swap_total)),
        ),
        "name": "memory",
        "color": "#d75f5f" if mem_available / mem_total < 0.1 else "#ffffff",
    })

    # IP ADDRESS

    ip = get_ip_address()

    if ip:
        blocks.append(
            {
                "full_text": " {} ".format(ip),
                "name": "ip",
                "color": "#a8ff60",
            }
        )

    # BATTERY

    battery = get_battery_status()

    if battery:
        pct = battery.get("percent", 0)
        status = battery.get("status", "Unknown")

        if status.lower().startswith("charging"):
            color = "#5fd75f"  # green-ish
        else:
            if pct <= 10:
                color = "#d75f5f"
            elif pct <= 30:
                color = "#d7af5f"
            else:
                color = "#ffffff"

        blocks.append(
            {
                "full_text": " BAT {}% ".format(pct),
                "name": "battery",
                "color": color,
            }
        )

    # TIME

    now = datetime.now().astimezone()
    now_pt = datetime.now(ZoneInfo("Europe/Lisbon"))

    if now.tzname() != now_pt.tzname():
        timeinfo_pt = now_pt.strftime("%a %d %b %H:%M")

        blocks.append({
            "full_text": " {} <i>{}</i> ".format(
                timeinfo_pt, now_pt.tzname()
            ),
            "name": "time-pt",
            "markup": "pango",
        })

    timeinfo = now.strftime("%a %d %b %H:%M")

    blocks.append({
        "full_text": " {} <i>{}</i> ".format(
            timeinfo, now.tzname()
        ),
        "name": "time",
        "markup": "pango",
    })

    # LAYOUT

    layout = get_kbd_layout()

    if layout:
        blocks.append({
            "full_text": " {} ".format(layout),
            "name": "layout",
        })

    return blocks


def main(poll_interval=2.0):
    # Header
    header = {"version": 1}
    print(json.dumps(header))

    # Start the array stream
    print("[")
    sys.stdout.flush()

    first = True  # track first update
    prev_total, prev_idle = get_cpu_times()

    try:
        while True:
            cur_total, cur_idle = get_cpu_times()
            cpu_usage = None  # initial nil value

            if prev_total and cur_total and prev_idle and cur_idle:
                delta_total = cur_total - prev_total
                delta_idle = cur_idle - prev_idle

                if delta_total > 0:
                    delta = delta_total - delta_idle
                    cpu_usage = delta / delta_total * 100.0
                else:
                    cpu_usage = 0.0

            if cur_total:
                prev_total, prev_idle = cur_total, cur_idle

            blocks = build_blocks(cpu_usage=cpu_usage)
            line = json.dumps(blocks)

            if first:
                # First element must not be prefixed with a comma
                sys.stdout.write(line + "\n")
                first = False
            else:
                # Subsequent elements must be prefixed with a comma
                sys.stdout.write("," + line + "\n")
            sys.stdout.flush()
            time.sleep(poll_interval)
    except KeyboardInterrupt:
        # Exit cleanly
        sys.exit(0)


if __name__ == "__main__":
    main()
