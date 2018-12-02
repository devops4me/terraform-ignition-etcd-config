
# --->
# ---> Going with Ubuntu's Long Term Support (lts)
# ---> version which is currently 18.04.
# --->

FROM ubuntu:18.04


# --->
# ---> Assume the root user and install git, terraform,
# ---> and pythonic tools both for retrieving the CoreOS
# ---> AMI ID and the CoreOS etcd discovery url.
# --->

USER root

RUN apt-get update && apt-get --assume-yes install -qq -o=Dpkg::Use-Pty=0 \
      curl            \
      git             \
      jq              \
      python-pip      \
      build-essential \
      libssl-dev      \
      libffi-dev      \
      python-dev      \
      tree            \
      unzip


# --->
# ---> The python script (ran by Terraform) for pulling
# ---> down an etcd cluster discovery url needs a REST API
# ---> package called requests.
# --->
RUN pip install requests


# --->
# ---> The documentation here explains the makeup of the
# ---> powerful useradd command.
# --->
# ---> https://linux.die.net/man/8/useradd
# --->

############## RUN useradd --home /home/tester --create-home --shell /bin/bash --gid root tester


# --->
# ---> Install the Terraform binary.
# --->

RUN \
    curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.9/terraform_0.11.9_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    chmod a+x /usr/local/bin/terraform         && \
    rm /tmp/terraform.zip                      && \
    terraform --version


########### # --->
########### # ---> As tester, we initialize terraform ready
########### # ---> for the apply command that will begin the
########### # ---> process of creating infrastructure.
########### # --->
######## USER tester
######## WORKDIR /home/tester

USER ubuntu
WORKDIR /home/ubuntu
