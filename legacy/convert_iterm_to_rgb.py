# Conversion script for Sidney_iTerm.json to ghostty config
import json
import sys
import re

data = json.load(sys.stdin)

for key in sorted(data.keys()):
    if m := re.match(r"Ansi (\d+) Color", key):
        components = data[key]
        r = int(components["Red Component"] * 255)
        g = int(components["Green Component"] * 255)
        b = int(components["Blue Component"] * 255)
        hex_color = f"#{r:02x}{g:02x}{b:02x}"
        print(f"# {key}: RGB({r}, {g}, {b}) -> {hex_color}")
        print(f"palette = {m.group(1)}={hex_color}")

