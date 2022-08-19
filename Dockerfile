FROM registry.access.redhat.com/ubi8/ubi:8.0 AS first
RUN echo I-AM-FROM-FIRST > /tmp/index.html
LABEL image=first


FROM registry.access.redhat.com/ubi8/ubi:8.0 AS second
MAINTAINER ANANDPAVITHRAN<apavithr@redhat.com>
ENV VAR1=apple\
     VAR2=grape
EXPOSE 8081
#RUN yum install -y --no-docs --disableplugin=subscription-manager httpd
RUN yum install -y httpd && yum install net-tools -y && yum install bind-utils -y && yum install iputils -y 
#RUN yum clean all --disableplugin=subscription-manager -y
COPY --from=first /tmp/index.html /var/www/html/index.html 
RUN sed -i "s/Listen 80/Listen 8081/g" /etc/httpd/conf/httpd.conf
RUN chgrp -R 0 /var/log/httpd /var/run/httpd /var/www/html && \ 
    chmod -R g=u /var/log/httpd /var/run/httpd /var/www/html
USER 1002
CMD bash -c "/usr/sbin/httpd -DFOREGROUND"
LABEL image=second

