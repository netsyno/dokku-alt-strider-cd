FROM ubuntu:trusty
MAINTAINER Kamil Trzcinski <ayufan@ayufan.eu>

# Configure environment
RUN apt-get  update
RUN apt-get install -y curl wget build-essential git make
RUN locale-gen en_US en_US.UTF-8 de_DE de_DE.UTF-8
RUN curl https://raw.github.com/isaacs/nave/master/nave.sh > /bin/nave && chmod a+x /bin/nave
RUN nave usemain stable

# Install Strider-CD
RUN useradd -m strider
RUN git clone https://github.com/Strider-CD/strider.git /src -b v1.7.7
WORKDIR /src
RUN apt-get install -y nodejs npm
RUN ln -s nodejs /usr/bin/node
RUN (rm -rf node_modules || exit 0) && npm install

# Install plugins
# RUN npm install strider-slack
# RUN npm install strider-gitlab
RUN npm install strider-ssh-deploy
RUN npm install strider-env strider-python strider-webhooks strider-simple-worker strider-git
RUN npm install strider-simple-runner
RUN npm install strider-email-notifier
RUN npm install strider-local strider-runner-core strider-extension-loader
# RUN npm install strider-dot-net
# RUN npm install strider-sauce
# RUN npm install strider-hipchat strider-build-badge strider-fleet strider-jelly

# Configure Strider-CD
RUN mkdir -p /strider/builds && chown -R strider:strider /strider
ENV STRIDER_CLONE_DEST /strider/builds
ENV SERVER_NAME https://strider.two.netsyno.com/
# USER strider
USER root

# Run Strider-CD
# EXPOSE 5000
