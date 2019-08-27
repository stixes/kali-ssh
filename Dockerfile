FROM kalilinux/kali-linux-docker:latest

# Configurable ENVs
ENV ROOT_PW toor
# for use with secrets
ENV ROOT_PW_FILE /run/secrets/rootpw
# If this file exists, and is executable, it will autorun on startup
# Use this to customize your installation
ENV AUTORUN_FILE /root/autorun.sh

# Set correct environment variables
ENV HOME /root/
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && \
    apt-get install -y \
        kali-linux \
        tmux \
        screen \
        ca-certificates \
        supervisor \
        metasploit-framework \
        dirb \
        wfuzz \
        sqlmap \
        exploitdb \
        weevely \
        net-tools \
        wordlists && \
    apt-get autoremove -y && \
    apt-get clean -y  && \
    updatedb && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen 

# Supervisord for starting ssh and postgresdb
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Bootstrap metasploit database
RUN supervisord && sleep 3 && msfdb init && pkill supervisord

# Expose Port
EXPOSE 4422

# DB contents
VOLUME /var/lib/postgresql/11/main
# Root home dir
VOLUME /root

# Add entrypoint
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
