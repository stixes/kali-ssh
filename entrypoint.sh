#!/bin/bash

# Ensure SH is ready for use
if [ -f /etc/ssh/sshd_config ]; then
  mkdir -p /run/sshd
  sed -i -r 's/^.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config
  sed -i -r 's/^.?PasswordAuthentication.+/PasswordAuthentication yes/' /etc/ssh/sshd_config
  sed -i -r 's/^.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
  sed -i -r 's/^.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config
  sed -i -r 's/^.?Port.+/Port 4422/' /etc/ssh/sshd_config
fi

# Update root user password
if [ -f "${ROOT_PW_FILE}" ]; then
  ROOT_PW=$(cat "${ROOT_PW_FILE}")
fi
echo "root:${ROOT_PW}"|chpasswd

# Run autoexec if avilable
if [ -x "${AUTORUN_FILE}" ] && [ ! -f /tmp/.autorun-has-run ]; then
  echo "Running autorun script.."
  ! ${AUTORUN_FILE} 
  touch /tmp/.autorun-has-run
  echo "Done."
fi

supervisord -n
