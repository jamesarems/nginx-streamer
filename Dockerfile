## Nginx Strem server container
# Clone official centos docker from dockerhub
FROM centos:8
MAINTAINER jamesarems@hotmail.com
VOLUME ["/data"]
# Copy script to container
COPY ./run.sh /opt/run.sh
# Execute permission
RUN chmod +x /opt/run.sh
# Create Nginx user
RUN useradd nginx
# Install dependencies
RUN yum install curl gcc gcc-c++ make pcre-devel openssl-devel git -y
# Clone & Download Nginx and RTMP module
RUN git clone https://github.com/arut/nginx-rtmp-module.git
RUN curl http://nginx.org/download/nginx-1.19.1.tar.gz -o nginx-1.19.1.tar.gz
# Compile and install nginx
RUN tar -xf nginx-1.19.1.tar.gz
RUN pushd nginx-1.19.1 ; ./configure --add-module=../nginx-rtmp-module --with-http_ssl_module --with-cc-opt="-Wimplicit-fallthrough=0" ; make ; make install ; popd
# Cleaning up tar files and caches
RUN rm -rf nginx-1.19.1.tar.gz nginx-1.19.1 nginx-rtmp-module
RUN yum clean all
# Remove default nginx conf
RUN rm -rf /usr/local/nginx/conf/nginx.conf
# Copy custom nginx config
COPY ./conf/nginx.conf /usr/local/nginx/conf/nginx.conf
# Expose required ports. 8080 for Streaming, 1935 RTMP
EXPOSE 8080 443 1935
# Everything begins here!
ENTRYPOINT /opt/run.sh
