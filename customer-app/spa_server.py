#!/usr/bin/env python3
"""
SPA-aware HTTP server for Flutter web (GoRouter client-side routing).

Key behaviours:
• Serves index.html for any path that doesn't map to a real file (SPA fallback).
• Sends Cache-Control: no-store for the service-worker script so the browser
  always fetches the latest version after a rebuild — avoids stale-SW lockout
  during development.
"""
import http.server
import os
import sys

PORT      = int(sys.argv[1]) if len(sys.argv) > 1 else 5000
DIRECTORY = sys.argv[2] if len(sys.argv) > 2 else "."

os.chdir(DIRECTORY)

# Files that must never be served from cache during development
NO_CACHE_PATTERNS = (
    "flutter_service_worker.js",
    "flutter_bootstrap.js",
    "main.dart.js",
    "index.html",
    "manifest.json",
)


class SPAHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Strip query/hash to get the bare file path
        bare = self.path.split("?")[0].split("#")[0]
        fs_path = os.path.join(os.getcwd(), bare.lstrip("/"))

        if os.path.isfile(fs_path):
            super().do_GET()
        else:
            # SPA fallback
            self.path = "/index.html"
            super().do_GET()

    def end_headers(self):
        bare = self.path.split("?")[0]
        name = os.path.basename(bare)
        if any(name.startswith(p.split(".")[0]) for p in NO_CACHE_PATTERNS):
            self.send_header("Cache-Control", "no-store, no-cache, must-revalidate")
            self.send_header("Pragma",        "no-cache")
            self.send_header("Expires",       "0")
        super().end_headers()

    def log_message(self, fmt, *args):
        pass   # suppress per-request noise


if __name__ == "__main__":
    with http.server.HTTPServer(("0.0.0.0", PORT), SPAHandler) as httpd:
        print(f"SPA server → http://0.0.0.0:{PORT}", flush=True)
        httpd.serve_forever()
