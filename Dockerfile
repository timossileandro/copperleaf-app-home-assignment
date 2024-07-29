FROM nginx:latest

COPY nginx.conf /etc/nginx/nginx.conf
COPY default.htm /usr/share/nginx/html/default.htm