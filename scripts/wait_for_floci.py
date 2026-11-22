"""BLOCK until Floci answers on its edgepoint"""

import os
import sys
import time
import urllib.error
import urllib.request

URL = os.environ.get("AWS_ENDPOINT_URL", "http://localhost:4566")
DEADLINE = time.monotonic() + 60

while time.monotonic() < DEADLINE:
    try:
        urllib.request.urlopen(URL, timeout=2)
        break  # SERVER UP
    except urllib.error.HTTPError:
        break  # SERVER UP
    except OSError:
        time.sleep(1)
else:
    sys.exit(f"Floci failed to respond at {URL}")
