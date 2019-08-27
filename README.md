# kali-ssh

Sometimes, you just need a basic toolbox to log into. This image will help :)

As a developer, often constrained to a Windows based pc, I wanted a toolbox
image. As I already work with docker (which messes up VirtualBox on Windows),
I figured a good image would be very useful when I wanted to do research and 
work on [Vulnhub](https://www.vulnhub.com/) machines, or on 
[HackTheBox](https://www.hackthebox.eu).
This image has all the basic tools you'd expect from a Kali distribution, 
along with a decent environment to work in, with locales and your basic 
utilities ready to work.
It will even run reasonably well on that NAS you have running all the time
anyway, as the base memory usage for this image in only ~25Mb!

Features:
* Automatically builds with new Kali releases
* screen / tmux ready to use
* vim / nano for your editing convenience
* Updated and DB backed Metasploit Framework
* Updates locales, to avoid pesky error messages
* Update apt, ready to install more tools
* locatedb updated
* Your basic wordlists
* With X-forwarding SSH, GUI tools can be installed and working

Both the database, and the /root is ready for volume use, and can be either 
mapped, or persisted to a named volume.

On container initialization a file defined in AUTORUN\_FILE environment 
(default is /root/autorun.sh) will be run. This allows for post startup
customization, like installing more tools.

Using this, and persisting /root, you can configure your experience to 
surviving container recreation, allowing for easy resets, and resource 
conservation.

# Purpose and usage

So, you need to quickly set up a metasploit handler.. or you're into that docker
based infrastructure and need a toolbox to pivot from.

Maybe you just need a Kali running in your background, rather then a full VM.

This image allows you to establish a ready-to-use and updated Kali linux for
just those situations! Just run it, and log in.

SSH is available on port 4422, this is to enable easier usage of --network="host".
Useful if you haven't planned out your reverse shells.

Example run command:

    docker run -d --rm -X --network=host stixes/kali-ssh

After which you can log into the kali using `ssh -p 4422 root@<docker host ip>` 
using `toor`as password.

with the -X flag, it is possible to install and use GUI tools (ie. apt install xterm; xterm)

The --rm flag allows the killing of supervisord (ie. kill 1) inside the container
to cause the container to self-destruct and remove any data from the host. 
Very useful in a "burn-after-use" scenario.

# Configuration 

## Root password

Root password is set using the ROOT\_PW environment variable. It is also possible to read the password from a file, if the file from ROOT\_PW\_FILE exists. This is useful if you're using Docker Swarm secrets (or some other secret mounting utility).

## Volumes

Root home folder was thought to be persisted. Using named volumes makes this easy:

    docker volume create kaliroot
    docker run --rm -v kaliroot:/root ... stixes/kali-ssh

This will allow /root to survive container recreation.

## Autorun

If a file defined in the AUTORUN\_FILE (default /root/autorun.sh) exists and is executable, this will be run at container initialization. This can be use to easily install utilities and tools not originally included in the image, and make the toolset available in the image consistent between recreates:

./root/autorun.sh:
```bash
#!/bin/sh
apt install -y xterm
```

    docker run -v $PWD/root:/root ... stixes/kali-ssh

This will make xterm available in the container, even after container was deleted and recreated.

## Docker compose

A reusable service based on docker-compose can be easily created:

```yaml
version: "2"
volumes:
  kaliroot:
services:
  kali:
    image: stixes/kali-ssh
    restart: always
    network_mode: host
    environment:
      ROOT_PW=nottoor
    volumes:
      kaliroot:/root
```

# More info and more tools

The basic tools are in there, along with metasploit, but to keep image size down
you may need to to install tools after starting.

Read more about Kali linux meta packages [here](https://www.kali.org/news/kali-linux-metapackages/).

# Disclaimer

As is common with these types of tools, the intended use is for education 
and otherwise approved activities. DO NOT use on any hosts or targets
without proper aproval.

However, you should get aproval and start improving security in your home or
organisation right away.

