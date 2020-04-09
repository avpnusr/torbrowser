![TOR Browser Logo](https://www.macupdate.com/images/icons256/17679.png)

**TorBrowser in docker container (for X11 server with GUI)**
===

This repository has multi architecture support and is regularly updated.    
Container is built for amd64, arm and arm64.

Versions in the latest image
-----
- [TorBrowser](https://www.torproject.org/ "TOR Project Homepage") Version: 9.0.9
- [Debian Base Image](https://hub.docker.com/_/debian "Debian Docker Repo") Version: stretch

Start your container
-----
Use the below start sequence to get a running TorBrowser displaying ob your host X11 server.   
Be aware, that this was of accessing the X11 server is not the safest, you will find more secure methods online.  
The consistent profile is quite a pain, but in most cases you want anonymity and nothing stored on the host!

```
docker run -it \
      --memory 1gb \
      -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
      -e DISPLAY=$DISPLAY \ # to display on your host X11
      -v $HOME/Downloads/torbrowser:/tmp/Downloads \ # to access your downloads on host
      -v $HOME/.config/tor:/opt/tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default \ # if you want consistent profile
      --device /dev/snd \ # to have sound output
      --device /dev/dri/card0 \ # to use graphics card acceleration (if needed)
      -v /dev/shm:/dev/shm \ 
      -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \ #might need a change to your system
     --name torbrowser \
      avpnusr/torbrowser:latest
```
   
If you close the browser window, you can restart the container any time with:     
```
docker start torbrowser
```
