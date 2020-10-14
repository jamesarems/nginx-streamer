## Nginx Stream server container
# Clone official centos docker from dockerhub
FROM centos:8
MAINTAINER James PS <jamesarems@hotmail.com>
VOLUME ["/data"]
# Copy script to container
COPY ./run.sh /opt/run.sh
# Execute permission
RUN chmod +x /opt/run.sh
# Create Nginx user
RUN useradd nginx
# Install dependencies
RUN dnf install curl gcc gcc-c++ make pcre-devel openssl-devel git -y
# Clone & Download Nginx, RTMP, VOD, Purge modules
RUN git clone https://github.com/arut/nginx-rtmp-module.git
RUN git clone -b 1.27 https://github.com/kaltura/nginx-vod-module.git
RUN git clone https://github.com/FRiCKLE/ngx_cache_purge.git
RUN curl http://nginx.org/download/nginx-1.19.1.tar.gz -o nginx-1.19.1.tar.gz
# Compile and install nginx
RUN tar -xf nginx-1.19.1.tar.gz
RUN pushd nginx-1.19.1 ; ./configure --add-module=../nginx-rtmp-module --add-module=../nginx-vod-module --add-module=../ngx_cache_purge --with-file-aio --with-http_ssl_module --with-cc-opt="-Wimplicit-fallthrough=0" ; make ; make install ; popd
#Install FFMPEG (Optional)
# Install FFMPEG
RUN dnf install epel-release dnf-utils -y
RUN dnf config-manager --enable PowerTools && dnf install --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm -y
RUN dnf install http://rpmfind.net/linux/epel/7/x86_64/Packages/s/SDL2-2.0.10-1.el7.x86_64.rpm -y
RUN dnf install ffmpeg ffmpeg-devel -y
# Cleaning up tar files and caches
RUN rm -rf nginx-1.19.1.tar.gz nginx-1.19.1 nginx-rtmp-module nginx-vod-module
RUN dnf clean all
# Remove default nginx conf
RUN rm -rf /usr/local/nginx/conf/nginx.conf
# Copy custom nginx config
COPY ./conf/nginx.conf /usr/local/nginx/conf/nginx.conf
# Expose required ports. 8080 for Streaming, 1935 RTMP
EXPOSE 8080 443 1935 80
# Everything begins here!
ENTRYPOINT /opt/run.sh
