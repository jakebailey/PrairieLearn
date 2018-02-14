FROM centos:7

# Needed for AWS to properly handle UTF-8
ENV PYTHONIOENCODING=UTF-8

RUN yum -y install \
        epel-release \
        https://rpm.nodesource.com/pub_8.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm \
        https://centos7.iuscommunity.org/ius-release.rpm \
    && yum -y update \
    && yum -y install \
        nodejs \
        python36u \
        python36u-pip \
        python36u-devel \
        gcc \
        make \
    && yum clean all \
    && ln -s /usr/bin/python3.6 /usr/bin/python3

# Install Python/NodeJS dependencies before copying code to limit download size
# when code changes.
COPY requirements.txt package.json /PrairieLearn/
RUN python3 -m pip install --no-cache-dir -r /PrairieLearn/requirements.txt \
    && cd /PrairieLearn \
    && npm install \
    && npm --force cache clean

# NOTE: Modify .dockerignore to whitelist files/directories to copy.
COPY . /PrairieLearn/

RUN chmod +x /PrairieLearn/docker/init.sh \
    && mv /PrairieLearn/docker/config.json /PrairieLearn \
    && mkdir /course

HEALTHCHECK CMD curl --fail http://localhost:3000/pl/webhooks/ping || exit 1
CMD /PrairieLearn/docker/init.sh
