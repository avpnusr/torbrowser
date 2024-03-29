FROM debian:12-slim
LABEL maintainer "avpnusr"

# Install TorBrowser
RUN     echo "deb http://deb.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list \
        && echo "deb http://security.debian.org/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list \
        && echo "deb http://deb.debian.org/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
        wget \
        curl \
        gpg \
        dirmngr \
        openssl \
        ca-certificates \
        xz-utils \
        libgtk-3-0 \
        libdbus-glib-1-2 \
        libxt6 \
        && LATESTASC=$(curl -s -N https://www.torproject.org/download/ | grep -Eo -m1 "/[a-zA-Z0-9./?=_-]*linux64.*.asc") \
        && LATESTXZ=$(curl -s -N https://www.torproject.org/download/ | grep -Eo -m1 "/[a-zA-Z0-9./?=_-]*linux64.*.xz") \
        && echo "### Downloading Tor-Browser ###" \
        && wget -q -O /opt/tor.tar.xz "https://www.torproject.org/$LATESTXZ" \
        && wget -q -O /opt/tor.tar.xz.asc "https://www.torproject.org/$LATESTASC" \
        && echo "### Verifying signature of downloaded TorBrowser ###" \
        # below line throws an error at the moment ... using workaround
        #&& gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org \
        && curl -s https://openpgpkey.torproject.org/.well-known/openpgpkey/torproject.org/hu/kounek7zrdx745qydx6p59t9mqjpuhdf | gpg --import - \
        && gpg --output /opt/tor.keyring --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290 \
        && gpgv --keyring /opt/tor.keyring /opt/tor.tar.xz.asc /opt/tor.tar.xz \
        && cd /opt && tar xfJ  tor.tar.xz &&  rm -f tor.tar.xz tor.tar.xz.asc tor.keyring && cd \
        && apt-get purge --auto-remove -y openssl dirmngr gpg wget curl xz-utils \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* ~/.gnupg \
        && groupadd -g 1000 -r tor && useradd -r -m -u 1000 -g tor -G audio,video tor \
        && mkdir /data && chown tor:tor /opt/tor-browser_en-US /data && cd /opt/tor-browser_en-US && chown -R tor:tor *

# Run TorBrowser as non privileged user
USER tor

# Autorun TorBrowser
ENTRYPOINT [ "/opt/tor-browser_en-US/Browser/start-tor-browser" ]
