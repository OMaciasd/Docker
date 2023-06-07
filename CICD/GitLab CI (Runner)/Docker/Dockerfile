#FROM ruby:2.5.1
FROM gitlab/gitlab-runner:latest

#variables
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB.UTF-8
ENV LC_ALL es_ES.UTF-8
ENV RAILS_ROOT /var/www/rails/etecnic/
ENV server_pass=wiggNzqC4jmedT
ENV server_ip=34.240.178.79
ENV server_ip=localhost
ENV RBENV_ROOT /usr/local/src/rbenv
ENV PATH ${RBENV_ROOT}/shims:${RBENV_ROOT}/bin:$PATH
ENV RUBY_VERSION 2.5.1

#install packages
RUN apt-get update -qy --fix-missing; apt-get install -y sudo; \
#vsftpd cpulimit awscli
#RUN sudo apt-get install -y  mysql-client db-util
#RUN sudo apt-get install -y  socat netcat
  sudo apt-get install -y nodejs python python3 python3-pip wget curl tcptraceroute iputils-ping net-tools \
  openssh-server sshpass libpq-dev libssl-dev libreadline-dev zlib1g-dev libmysqlclient-dev libsqlite3-dev \
  libfontconfig1 libxrender1 nano locales apt-utils build-essential cron git logrotate; \
  sudo chmod 755 /usr/bin/tcpping; \
#add parameters for ssh
  chmod 771 /etc/ssh/sshd_config; echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config; \
  echo "PermitRootLogin yes" >> /etc/ssh/sshd_config; \
  echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com" >> /etc/ssh/sshd_config; \
  echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256" >> /etc/ssh/sshd_config; \
  echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com" >> /etc/ssh/sshd_config; \
#install tzdata and configure
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata; \
  sudo ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime; \
  sudo dpkg-reconfigure --frontend noninteractive tzdata; \
#install tzdata and configure
  DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata; \
  ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime; \
  dpkg-reconfigure --frontend noninteractive tzdata; \
#configure locales
  dpkg-reconfigure -f noninteractive tzdata; \
  sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen; \
  sed -i -e 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen; \
  echo 'LANG="en_GB.UTF-8"'>/etc/default/locale; \
  echo 'LANGUAGE="en_GB.UTF-8"'>/etc/default/locale; \
  echo 'LC_CTYPE="en_GB.UTF-8"'>/etc/default/locale; \
  echo 'LC_NUMERIC="es_ES.UTF-8"'>/etc/default/locale; \
  echo 'LC_TIME="es_ES.UTF-8"'>/etc/default/locale; \
  echo 'LC_COLLATE="en_GB.UTF-8"'>/etc/default/locale; \
  echo 'LC_MONETARY="es_ES.UTF-8"'>/etc/default/locale; \
  echo 'LC_MESSAGES="en_GB.UTF-8"'>/etc/default/locale; \
  echo 'LC_PAPER="es_ES.UTF-8"'>/etc/default/locale; \
  echo 'LC_NAME="es_ES.UTF-8"'>/etc/default/locale; \
  echo 'LC_ADDRESS="es_ES.UTF-8"'>/etc/default/locale; \
  echo 'LC_TELEPHONE="es_ES.UTF-8"'>/etc/default/locale; \
  echo 'LC_MEASUREMENT="es_ES.UTF-8"'>/etc/default/locale; \
  echo 'LC_IDENTIFICATION="es_ES.UTF-8"'>/etc/default/locale; \
  dpkg-reconfigure --frontend=noninteractive locales; \
  update-locale LANG=en_GB.UTF-8; \
  chmod 700 /root/.ssh/; chmod 600 /root/.ssh/id_rsa; chmod 600 /root/.ssh/id_rsa.pub; \
  sudo mkdir -p ${RAILS_ROOT}/shared/log; sudo chmod 777 ${RAILS_ROOT}/shared/log; \
#RUN sudo touch ../shared/log/puma.log
#RUN sudo chmod 777 ../shared/log/puma.log
  sudo chmod 777 ${RAILS_ROOT}; \
#install RBENV
  sudo git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT}; \
  sudo git clone https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build; \
  sudo ${RBENV_ROOT}/plugins/ruby-build/install.sh; sudo chmod -R 771 /etc/profile.d; \
  sudo echo 'export RBENV_ROOT=/usr/local/src/rbenv' >> /etc/profile.d/rbenv.sh; \
  sudo echo 'export PATH=/usr/local/src/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh; \
  sudo echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh; rbenv install $RUBY_VERSION; \
  rbenv global $RUBY_VERSION; gem install bundler -v 1.17.2; gem install net-ssh -v 6.1.0; \
  gem install capistrano -v 3.11.2

COPY docker_staging/ssh/.ssh/* /root/.ssh/

#USER deployer
#RUN sudo chown -R deployer .bundle

# Adding project files
#ADD . ./

#RUN sudo chown -R deployer ./
#RUN sudo chown -R deployer ../shared

#RUN sudo cp config/database.yml.example config/database.yml || true
#RUN sudo cp -r config/* ../shared/config/ || true
#RUN bundle exec rake secret

#RUN sudo chmod -R 771 /usr/local/src/rbenv/
#RUN bundle exec rake assets:precompile

#ftp
#RUN sudo mkdir /srv/ftp/logs
#RUN chmod 777 /srv/ftp/logs
#RUN chown nobody:nogroup /srv/ftp/logs

#RUN sudo mkdir /srv/ftp/firmwares
#RUN chmod 777 /srv/ftp/firmwares
#RUN chown nobody:nogroup /srv/ftp/firmwares

# COPY docker/ftp/vsftpd.conf /etc/vsftpd.conf
# COPY docker/ftp/vsftpd.chroot_list /etc/vsftpd.chroot_list

# COPY docker/ftp/hosts.allow /etc/hosts.allow
# COPY docker/ftp/hosts.deny /etc/hosts.deny

#RUN sudo mkdir /etc/vsftpd
#COPY docker/ftp/vusers.txt /etc/vsftpd/vusers.txt
#RUN db_load -T -t hash -f /etc/vsftpd/vusers.txt /etc/vsftpd/vsftpd-virtual-user.db || true
#RUN chmod 600 /etc/vsftpd/vsftpd-virtual-user.db || true
#RUN rm /etc/vsftpd/vusers.txt || true
#COPY docker/ftp/vsftpd.virtual /etc/pam.d/vsftpd.virtual

#exposed ports
#EXPOSE 3000 2000 2500

#WORKDIR /var/www/rails/etecnic/current

#RUN cap production deploy

#comands run at start docker
#1-change pass root
#2-copy ssh id to localhost for capistrano
#3-tail command for docker not exit at finish
CMD sudo service ssh start; sudo service cron start; \
#&& sudo service vsftpd start \
  sudo echo "root:${server_pass}" | sudo chpasswd; sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "localhost"; \
  sudo sshpass -p "${server_pass}" ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@localhost -f; \
  sudo ssh-keygen -f "/root/.ssh/known_hosts" -R "${server_ip}"; \
#&& cap production deploy \
#&& cap production puma_jobs:start \
#&& bundle exec rails db:seed RAILS_ENV=production \
#&& rm -f /var/www/rails/etecnic/current/log/logs_aws_time \
#&& sudo python /var/www/rails/etecnic/current_docker/aws_logs/awslogs-agent-setup.py --region eu-west-1 --non-interactive --configfile=/root/awslogs/awslogs.conf \
  tail -f /dev/null

ADD http://www.vdberg.org/~richard/tcpping /usr/bin

#&& cap production deploy \
#&& bundle exec puma -C config/puma.rb
