FROM debian:latest

# execute the folowing RUNs as root
USER root

# install Java and Maven
RUN apt-get update \
 && apt-get install -yq \
      curl \
      gnupg \
      git \
      openjdk-11-jdk-headless \
      maven
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# install 'gcloud' and 'kubectl' cli commands
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
 && apt-get install -yq apt-transport-https ca-certificates \
 && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
 && apt-get update \
 && apt-get install -yq google-cloud-sdk kubectl

# (optional) add a Gitpod user
RUN addgroup --gid 33333 gitpod \
 && useradd --create-home --home-dir /home/gitpod --shell /bin/bash --uid 33333 --gid 33333 gitpod

# switch to user Gitpod.
USER gitpod

# the prompt in the Bash Terminal should show 'applitools' and not the current user name
RUN { echo && echo "PS1='\[\e]0;gitpod \w\a\]\[\033[01;32m\]gitpod\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> /home/gitpod/.bashrc

