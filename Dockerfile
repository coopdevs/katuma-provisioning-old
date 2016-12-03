# It will require something like the following in /usr/local/etc/ansible/hosts
# for Ansible to provision it
#
#   [katuma-dev]
#   0.0.0.0 ansible_port=32774 ansible_user=root
#
# Steps to create the machine:
# 
# docker build -t sshd .
# docker run -d -P --name test_sshd sshd
# docker ps
# ssh ubuntu@0.0.0.0 -p 32774
# ssh ubuntu@0.0.0.0 -p 32775
# sudo vim /usr/local/etc/ansible/hosts
# ssh-copy-id root@0.0.0.0 -p 32775
# ssh root@0.0.0.0 -p 32774
# ssh root@0.0.0.0 -p 32775
# ansible-playbook development.yml -v --ask-sudo-pass --ask-vault-pass
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server python2.7-minimal sudo
RUN ln -s /usr/bin/python2.7 /usr/bin/python

RUN mkdir /var/run/sshd
RUN echo 'root:kakaka22' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN useradd -d /home/ubuntu -m ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd
RUN usermod -aG sudo ubuntu

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
