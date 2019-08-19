FROM ruby:2.6-stretch
LABEL maintainer "Grzegorz Bizon <grzegorz@gitlab.com>"
ENV DEBIAN_FRONTEND noninteractive

ARG GIT_VERSION
ENV GIT_VERSION 2.23.0

##
# Update APT sources and install some dependencies
#
RUN sed -i "s/httpredir.debian.org/ftp.us.debian.org/" /etc/apt/sources.list
RUN apt-get update && apt-get install -y wget unzip xvfb gettext

##
# Install latest git
#
RUN mkdir /tmp/git-${GIT_VERSION} && \
  cd /tmp/git-${GIT_VERSION} && \
  wget -q https://github.com/git/git/archive/v${GIT_VERSION}.zip && \
  unzip -q v${GIT_VERSION}.zip && \
  cd git-${GIT_VERSION} && \
  make prefix=/usr/local all install && \
  cd /tmp && \
  rm -rf /tmp/git-${GIT_VERSION}

ARG GIT_LFS_VERSION
ENV GIT_LFS_VERSION 2.8.0

##
# Install latest git-lfs
#
RUN mkdir /tmp/git-lfs-${GIT_LFS_VERSION} && \
  cd /tmp/git-lfs-${GIT_LFS_VERSION} && \
  wget -q https://github.com/git-lfs/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-arm64-v${GIT_LFS_VERSION}.tar.gz && \
  tar xzf git-lfs-linux-arm64-v${GIT_LFS_VERSION}.tar.gz && \
  mv git-lfs /usr/local/bin && \
  chmod 755 /usr/local/bin/git-lfs && \
  cd /tmp && \
  rm -rf /tmp/git-lfs-${GIT_LFS_VERSION}

##
# Install Docker
#
RUN wget -q https://download.docker.com/linux/static/stable/x86_64/docker-17.09.0-ce.tgz && \
    tar -zxf docker-17.09.0-ce.tgz && mv docker/docker /usr/local/bin/docker && \
    rm docker-17.09.0-ce.tgz

##
# Install Google Chrome version with headless support
#
RUN curl -sS -L https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN apt-get update -q && apt-get install -y google-chrome-stable && apt-get clean

##
# Install chromedriver to make it work with Selenium
#
RUN wget -q https://chromedriver.storage.googleapis.com/$(wget -q -O - https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/local/bin

##
# Install gcloud and kubectl CLI used in Auto DevOps test to create K8s
# clusters
#
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get -y install google-cloud-sdk kubectl

##
# Cleanup
#
RUN apt-get clean -y && apt-get auto-remove -y && rm -rf /var/lib/apt/lists/*

WORKDIR /home/gitlab/qa
COPY ./qa/Gemfile* /home/gitlab/qa/
COPY ./config/initializers/0_inject_enterprise_edition_module.rb /home/gitlab/config/initializers/
COPY ./lib/gitlab.rb /home/gitlab/lib/
COPY ./INSTALLATION_TYPE /home/gitlab/
COPY ./VERSION /home/gitlab/
RUN cd /home/gitlab/qa/ && bundle install
COPY ./qa /home/gitlab/qa

ENTRYPOINT ["bin/test"]
