FROM node:14-buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y curl vim unzip nginx less

ENV FLYWAY_DIR=/usr/local/lib/flyway-6.3.1
RUN wget -q -O /tmp/flyway-commandline-6.3.1-linux-x64.tar.gz \
         https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/6.3.1/flyway-commandline-6.3.1-linux-x64.tar.gz \
    && mkdir -p /usr/local/lib/ \
    && tar -C /usr/local/lib/ -xzf /tmp/flyway-commandline-6.3.1-linux-x64.tar.gz \
    && rm -rf /tmp/*

# Playwright dependencies:
# https://github.com/microsoft/playwright/blob/master/utils/docker/Dockerfile.bionic
# === INSTALL BROWSER DEPENDENCIES ===

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Install WebKit dependencies \
    libwoff1 \
    libopus0 \
    libwebp6 \
    libwebpdemux2 \
    libenchant1c2a \
    libgudev-1.0-0 \
    libsecret-1-0 \
    libhyphen0 \
    libgdk-pixbuf2.0-0 \
    libegl1 \
    libnotify4 \
    libxslt1.1 \
    libevent-2.1-6 \
    libgles2 \
    libvpx5 \
    libxcomposite1 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libepoxy0 \
    libgtk-3-0 \
    libharfbuzz-icu0 \
    \
    # Install gstreamer and plugins to support video playback in WebKit. \
    libgstreamer-gl1.0-0 \
    libgstreamer-plugins-bad1.0-0 \
    gstreamer1.0-plugins-good \
    gstreamer1.0-libav \
    \
    # Install Chromium dependencies \
    libnss3 \
    libxss1 \
    libasound2 \
    fonts-noto-color-emoji \
    libxtst6 \
    \
    # Install Firefox dependencies \
    libdbus-glib-1-2 \
    libxt6

# Install playwright browsers in a shared folder so next installations
# of playwright in this image will use the one provided by default
ENV PLAYWRIGHT_BROWSERS_PATH=/root/shared-playwright-browsers

RUN npm i -D -g --unsafe-perm=true --allow-root playwright

# images inheriting this one should not download browsers again
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1


