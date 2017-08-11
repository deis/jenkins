FROM jenkins/jenkins:2.73

COPY plugins.txt /usr/share/jenkins/plugins.txt

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt \
  && mkdir -p /usr/share/jenkins/ref/secrets/ \
  && echo "false" > /usr/share/jenkins/ref/secrets/slave-to-master-security-kill-switch
