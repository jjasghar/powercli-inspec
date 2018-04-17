FROM ubuntu:16.04

MAINTAINER JJ Asghar <jj@chef.io>

ARG GEM_SOURCE=https://rubygems.org
ARG INSPEC_VERSION=2.1.43
ARG RUBY_VERSION=2.5.1

# Set terminal. If we don't do this, weird readline things happen.
ENV TERM linux
RUN echo "/usr/bin/pwsh" >> /etc/shells && \
    echo "/bin/pwsh" >> /etc/shells

# Install PowerShell
RUN apt-get update && \
    apt-get install -y curl apt-transport-https wget openssl && \
    curl https://packages.microsoft.com/keys/microsoft.asc > MS.key && \
    apt-key add MS.key && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list && \
    apt-get update && \
    apt-get install -y powershell

# Set working directory
WORKDIR /root/profiles

RUN mkdir -p ~/.local/share/powershell/Modules

# Install VMware modules from PSGallery
SHELL [ "pwsh", "-command" ]
RUN Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
RUN Install-Module VMware.PowerCLI,PowerNSX,PowervRA

# Install Ruby
SHELL [ "/bin/bash", "-c" ]
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -L https://get.rvm.io | bash -s stable && \
    /bin/bash -l -c "rvm requirements" && \
    /bin/bash -l -c "rvm install ${RUBY_VERSION}" && \
    /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Installing InSpec
RUN source /etc/profile.d/rvm.sh && \
    gem install --no-document --source ${GEM_SOURCE} --version ${INSPEC_VERSION} inspec && \
    echo 'source /etc/profile.d/rvm.sh' >> /root/.bashrc

# Final clean up
RUN apt-get remove -y --purge curl apt-transport-https wget openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Make the volume mount happen at ~/profiles
VOLUME ["/root/profiles"]

# Default to bash
CMD ["/bin/bash"]
