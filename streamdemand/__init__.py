from flask import Flask, abort, redirect, request
import streamlink

app = Flask(__name__)


@app.route("/_/<path:stream_url>")
def stream(stream_url):
    if not stream_url.startswith('http'):
        stream_url = f"https://{stream_url}"

    if request.query_string:
        stream_url += f"?{request.query_string.decode('utf-8')}"

    streams = streamlink.streams(stream_url)
    if not streams:
        abort(404, f"No streams found for {stream_url}")

    return redirect(streams['best'].url)
