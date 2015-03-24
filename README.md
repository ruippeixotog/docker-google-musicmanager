# ruippeixotog/google-musicmanager Docker image

This repository contains the Dockerfile for `ruippeixotog/google-musicmanager`, a Docker image containing Google Music Manager - the application which allows uploading of local music files for use with the Google Play Music service.

At the time of writing, there is no way to run the application as a headless service. The image relies on the method described [here](http://superuser.com/questions/429153/using-google-music-manager-in-linux-from-the-command-line), which involves launching a lightweight X11 display server ([Xvfb](http://en.wikipedia.org/wiki/Xvfb)) and a VNC server ([x11vnc](http://www.karlrunge.com/x11vnc/)).

## How to run

There are two ways to pass the required Google account credentials to this image.

The credentials can be passed through environment variables by running a container with:

```
docker run -dt -v /music:/music -v /appdata:/appdata \
  -e SERVER_NAME=some_name -e GOOGLE_USER=my_username -e GOOGLE_PASS=my_password \
  ruippeixotog/google-musicmanager
```

Using environment variables won't work if the Google account has two-step authentication enabled. If that is the case or if writing passwords in plain text is not desirable, the container can be run instead with:

```
docker run -dt -v /music:/music -v /appdata:/appdata \
  -e SERVER_NAME=some_name -p 5900:5900 \
  ruippeixotog/google-musicmanager
```

This exposes port 5900, in which a VNC server allows remote access to the Music Manager sign-in GUI. One can then connect using a client such as [VNC Viewer](https://www.realvnc.com/download/viewer/) and manually sign in. As long as the container is not destroyed, this process should only be needed once.

## Ports

* **5900** - The port exposed by the VNC server.

## Volumes

* **/appdata** - The working directory of Google Music Manager, where application logs and internal database files are stored;
* **/music** - The music directory that should be synchronized with Google Play Music.

## Environment variables

* **SERVER_NAME** - A unique name for the Music Manager instance;
* **GOOGLE_USER** - The Google account username;
* **GOOGLE_PASS** - The Google account password.

## Bugs

The current stable version of x11vnc has a bug where a buffer overflow occurs when IPv6 is not available in the host machine, as explained by [this post](http://mispdev.blogspot.pt/2014/04/x11vnc-avoiding-buffer-overflow-when.html). If you experience this problem please use the `ruippeixotog/google-musicmanager:dev` image, which uses a dev version of x11vnc.
