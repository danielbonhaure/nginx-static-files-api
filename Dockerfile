
##################################################################
##                           README                             ##
##################################################################
## ...                                                          ##
##################################################################



##########################
## Set GLOBAL arguments ##
##########################

# Set Error Message
ARG ErrorMessage="El archivo solicitado no existe."

# Set Static Files Folder
ARG StaticFilesFolder="static"

# Set the Reverse Proxy Path
ARG ReverseProxyPath



####################################
## Stage 1: Creat and Setup Image ##
####################################

# Create and Setup Image
FROM nginx

# Renew ARGs
ARG ErrorMessage
ARG StaticFilesFolder
ARG ReverseProxyPath

# Enable File Compression
RUN sed -i "s|#gzip|gzip|g" /etc/nginx/nginx.conf

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Edit the Nginx configuration file
RUN sed -i "s|static|${StaticFilesFolder}|g" /etc/nginx/conf.d/default.conf

# Copy the 404.html file
COPY 404.html /usr/share/nginx/html/404.html
# Edit the 404.html file
RUN sed -i "s|404 Not Found|${ErrorMessage}|g" /usr/share/nginx/html/404.html

# Copy the index.html file
COPY index.html /usr/share/nginx/html/index.html
# Edit the index.html file
RUN [ ${ReverseProxyPath:-"unset"} != "unset" ] \
    && sed -i "/let rproxy_path/ s|\"\"|\"${ReverseProxyPath}\"|g" \
       /usr/share/nginx/html/index.html \
    || :  # para entender porque :, ver https://stackoverflow.com/a/49348392/5076110

# Create the folder to host Static Files
RUN mkdir -p /usr/share/nginx/${StaticFilesFolder}/



#####################################################
## Usage: Commands to Build and Run this container ##
#####################################################

# docker build --tag custom-nginx:latest .

# docker run --name static-files-api \
# --mount type=bind,src=/data/static-data-1,dst=/usr/share/nginx/static/folfer-1,ro \
# --mount type=bind,src=/data/static-data-2,dst=/usr/share/nginx/static/folder-2,ro \
# --publish 8080:80 \
# --restart unless-stopped \
# --detach custom-nginx:latest
