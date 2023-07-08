#!/bin/bash/usr env

docker run -it --name postgres_release12 -e DEBIAN_FRONTEND=noninteractive ubuntu:20.04

apt update; apt install -y nano wget ca-certificates curl gnupg lsb-release;
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg;
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list';
apt update;
apt -y install postgresql-12;
ln -s /usr/lib/postgresql/12/bin/* /usr/sbin/;
rm -rf /var/lib/postgresql/12/main/*;
apt install -y etcd;
apt -y install python3 python3-pip python3-dev libpq-dev python3-etcd;
ln -s /usr/bin/python3 /usr/bin/python;
pip3 install launchpadlib --upgrade setuptools psycopg2;
apt install -y patroni;
apt install -y pgbouncer;
nano /etc/environment
export PGDATA="/var/lib/postgresql/12/main"
export ETCDCTL_API="3"
export PATRONI_ETCD_URL="http://127.0.0.1:2379"
export PATRONI_SCOPE="pg_cluster"
postgres1111=192.168.3.101
postgres1112=192.168.3.102
postgres1113=192.168.3.103
ENDPOINTS=$postgres1111:2379,$postgres1112:2379,$postgres1113:2379
