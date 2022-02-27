from flask import Flask, abort, redirect, url_for
import streamlink

app = Flask(__name__)

@app.route("/_/<path:stream_url>")
def stream(stream_url):
    if not stream_url.startswith('http'):
        stream_url = f"https://{stream_url}"

    streams = streamlink.streams(stream_url)
    if not streams:
        abort(404, f"No streams found for {stream_url}")

    return redirect(streams['best'].url)
