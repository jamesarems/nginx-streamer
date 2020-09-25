# Nginx Stream Server on CentOS 8 Container

## Usage

`docker run -itd --name stream-server -p 8080:8080 -p 1935:1935 -v /data:/data jamesarems/nginx-streamer:latest`

* 8080/tcp - For stream access
* 1935  - RTMP input
* 443 - (Optional) for SSL
* /data - Recorded data will available as `flv` format.

RTMP Stream point is available at `rtmp://<hostname>/hls/<stream-name>` and stream link will available at `http://<hostname>:8080/hls/<stream-name>/index.m3u8`

Eg : ``` ffmpeg -re -i example-vid.mp4 -vcodec libx264 -vprofile baseline -g 30 -acodec aac -strict -2 -f flv rtmp://localhost/hls/mystream ```

