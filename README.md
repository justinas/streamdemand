# streamdemand

Streamlink on demand.
A dead-simple HTTP proxy that allows your player to "directly"
play web streams, utilizing [streamlink](https://github.com/streamlink/streamlink).

<!-- vim-markdown-toc GFM -->

* [Running](#running)
* [How it differs from streamlink's `--player-external-http` option](#how-it-differs-from-streamlinks---player-external-http-option)
* [Common problems](#common-problems)
    * [URLs containing anchors (hashes)](#urls-containing-anchors-hashes)

<!-- vim-markdown-toc -->

## Running

Using Python, in a virtual environment:

```console
$ pip install git+https://github.com/justinas/streamdemand.git
$ gunicorn streamdemand:app
```

Or using Nix:

```console
$ nix-build https://github.com/justinas/streamdemand/archive/master.tar.gz
$ ./result/bin/gunicorn streamdemand:app
```

Then, simply point your player to a stream you want to watch:

```vlc
$ vlc 'http://localhost:8000/_/youtube.com/watch?v=5qap5aO4i9A'
```

Streamdemand should work with all of the sites
[supported by Streamlink](https://streamlink.github.io/plugin_matrix.html).

## How it differs from streamlink's `--player-external-http` option

The `--player-external-http` option allows streamlink to serve the resolved stream through HTTP.
However, this requires one to run an instance of streamlink per player / per client.

Streamdemand works in a different way.
Assuming you have it running on `localhost:8000`, you can point your player directly to e.g.
`http://localhost:8000/_/youtube.com/watch?v=5qap5aO4i9A`.
Streamdemand will resolve the stream URL using streamlink,
and will redirect your player to the stream.

This way, you do not have to worry about interacting with the streamlink CLI.
You can even make an M3U playlist to feed into supporting apps,
with all of your favorite streams:

```
#EXTM3U
#EXTINF:-1,Lofi Girl
http://localhost:8000/_/youtube.com/watch?v=5qap5aO4i9A
#EXTINF:-1,Monstercat
http://localhost:8000/_/twitch.tv/monstercat
#EXTINF:-1,LRT Lituanica
http://localhost:8000/_/lrt.lt/mediateka/tiesiogiai/lrt-lituanica
```

I use a similar playlist to integrate the streams into the "Live TV" functionality of Jellyfin.

Another difference is that rather than proxying the stream data,
Streamdemand simply issues a redirect to the actual stream URL,
which the player then follows. As such, it uses very little additional resources.

## Common problems

### URLs containing anchors (hashes)

In an URL like `https://lnk.lt/tiesiogiai#infotv`,
the "anchor" part (`#infotv`) is not sent to the server by the HTTP client.
Due to that, the hash symbol has to be URL-encoded for streamdemand to pick it up:
`http://localhost:8000/_/https://lnk.lt/tiesiogiai%23infotv`.
