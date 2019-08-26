# kali-ssh

Sometimes, you just need a basic toolbox to log into. This image will help :)

# Purpose and usage

So, you need to quickly set up a metasploit handler.. or you're into that docker
based infrastructure and need a toolbox to pivot from.

Maybe you just need a Kali running in your background, rather then a full VM.

This image allows you to establish a ready-to-use and updated Kali linux for
just those situations! Just run it, and log in.

SSH is available on port 4422, this is to enable easier usage of --network="host".
Useful if you haven't planned out your reverse shells.

Example run command:

    docker run -d --rm --network=host -v /:/host stixes/kali-ssh

After which you can log into the kali using `ssh -p 4422 root@<docker host ip>` 
using `toor`as password.

The --rm flag allows the killing of supervisord (ie. pkill supervisor or kill -9 -1)
inside the container to cause the container to self-destruct and remove any data
from the host. Very useful in a "burn-after-use" scenario.

# More info and more tools

The basic tools are in there, along with metasploit, but to keep image size down
you may need to to install tools after starting.

Read more about Kali linux meta packagere (here)[https://www.kali.org/news/kali-linux-metapackages/].

# Disclaimer

As is common with these types of tools, the intended use is for education 
and otherwise approved activities. DO NOT use on any hosts or targets
without proper aproval.

However, you should get aproval and start improving security in your home or
organisation right away.

