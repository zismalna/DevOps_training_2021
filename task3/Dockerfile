FROM ubuntu:latest
ENV DEVOPS="mlopaiev"
ENV index="/var/www/html/index.nginx-debian.html"
RUN apt-get update && \
apt-get install -y nginx
COPY ./task3.sh /tmp
RUN bash /tmp/task3.sh
EXPOSE 80
STOPSIGNAL SIGQUIT
CMD tac $index | sed '3d' | tac > /tmp/test.html && mv /tmp/test.html $index && \
sed -i "14 a $MYNAME Sandbox 2021" $index && \
nginx -g 'daemon off;'