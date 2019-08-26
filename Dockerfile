FROM kalilinux/kali-linux-docker:latest

# Set correct environment variables
ENV HOME /root/
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN echo -n "root:toor"|chpasswd && \
    apt-get update && \
    apt-get install -y \
        kali-linux \
        tmux \
        screen \
        ca-certificates \
        supervisor \
        metasploit-framework && \
    apt-get dist-upgrade -y && \
    apt-get autoremove -y && \
    apt-get clean -y  && \
    updatedb && \
    mkdir /run/sshd && \
    sed -i -r 's/^.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config && \
    sed -i -r 's/^.?PasswordAuthentication.+/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i -r 's/^.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    sed -i -r 's/^.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i -r 's/^.?Port.+/Port 4422/' /etc/ssh/sshd_config

# Supervisord for starting ssh and postgresdb
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Bootstrap metasploit database
RUN supervisord && sleep 3 && msfdb init && pkill supervisord

# Expose Port
EXPOSE 4422

# DB contents
VOLUME /var/lib/postgresql/11/main

CMD ["/usr/bin/supervisord","-n"]
