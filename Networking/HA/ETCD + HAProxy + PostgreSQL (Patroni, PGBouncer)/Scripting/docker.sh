#!/bin/bash/usr env

# Docker Settings.
docker commit postgres_release12 postgres12_ha_image;
docker rm postgres_release12;
docker network create -d bridge --subnet=192.168.3.0/24 pg_network3;
docker create -it --network pg_network3 --ip 192.168.3.101 -h postgres1111 --name postgres1111 postgres12_ha_image
docker create -it --network pg_network3 --ip 192.168.3.102 -h postgres1112 --name postgres1112 postgres12_ha_image
docker create -it --network pg_network3 --ip 192.168.3.103 -h postgres1113 --name postgres1113 postgres12_ha_image
docker start postgres1111 postgres1112 postgres1113

# ------------------------------------
# PostgreSQL - postgres1111 Settings.
# ------------------------------------
docker exec -it postgres1111 bash -c "nano /etc/hosts"
192.168.3.101   postgres1111
192.168.3.102   postgres1112
192.168.3.103   postgres1113

# ETCD - postgres1111 Settings.
docker exec -it postgres1111 bash -c "mv /etc/default/etcd /etc/default/etcd-orig"
docker exec -it postgres1111 bash -c "nano /etc/default/etcd"
ETCD_NAME=postgres1111
ETCD_DATA_DIR="/var/lib/etcd/postgres1111"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.3.101:2380"
ETCD_INITIAL_CLUSTER="postgres1111=http://192.168.3.101:2380,postgres1112=http://192.168.3.102:2380,postgres1113=http://192.168.3.103:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ENABLE_V2="true"

# Patroni - postgres1111 Settings.
docker exec -it postgres1111 bash -c "nano /etc/patroni/postgres.yml"
scope: pg_cluster
namespace: /service/
name: postgres1111

restapi:
    listen: postgres1111:8008
    connect_address: postgres1111:8008

etcd:
    hosts: postgres1111:2379,postgres1112:2379,postgres1113:2379

bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    postgresql:
      use_pg_rewind: true
      use_slots: true
      parameters:

  initdb:
  - encoding: UTF8
  - data-checksums

  pg_hba:
  - host replication replicator 127.0.0.1/32 md5
  - host replication replicator 0.0.0.0/0 md5
  - host all all 0.0.0.0/0 md5

  users:
    admin:
      password: admin
      options:
        - createrole
        - createdb

postgresql:
  listen: postgres1111:5432
  connect_address: postgres1111:5432
  proxy_address: postgres1111:6432
  data_dir: /var/lib/postgresql/12/main
  bin_dir: /usr/lib/postgresql/12/bin
  pgpass: /tmp/pgpass
  authentication:
    replication:
      username: replicator
      password: replicator
    superuser:
      username: postgres
      password: postgres
    rewind:
      username: rewind
      password: rewind

tags:
    nofailover: false
    noloadbalance: false
    clonefrom: false
    nosync: false

# pgbouncer - postgres1111 Settings.
docker exec -it postgres1111 bash -c "nano /etc/pgbouncer/pgbouncer.ini"
* = host=postgres1111 port=5432 dbname=postgres
listen_addr = *
auth_user = pgbouncer
auth_query = SELECT p_user, p_password FROM public.lookup($1)

# ------------------------------------
# ETCD - postgres1112 Settings.
# ------------------------------------
docker exec -it postgres1112 bash -c "nano /etc/hosts"
192.168.3.101   postgres1111
192.168.3.102   postgres1112
192.168.3.103   postgres1113

docker exec -it postgres1112 bash -c "mv /etc/default/etcd /etc/default/etcd-orig"
docker exec -it postgres1112 bash -c "nano /etc/default/etcd"
ETCD_NAME=postgres1112
ETCD_DATA_DIR="/var/lib/etcd/postgres1112"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.3.102:2380"
ETCD_INITIAL_CLUSTER="postgres1111=http://192.168.3.101:2380,postgres1112=http://192.168.3.102:2380,postgres1113=http://192.168.3.103:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ENABLE_V2="true"

# Patroni - postgres1112 Settings.
docker exec -it postgres1112 bash -c "nano /etc/patroni/postgres.yml"
scope: pg_cluster
namespace: /service/
name: postgres1112

restapi:
    listen: postgres1112:8008
    connect_address: postgres1112:8008

etcd:
    hosts: postgres1111:2379,postgres1112:2379,postgres1113:2379

bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    postgresql:
      use_pg_rewind: true
      use_slots: true
      parameters:

  initdb:
  - encoding: UTF8
  - data-checksums

  pg_hba:
  - host replication replicator 127.0.0.1/32 md5
  - host replication replicator 0.0.0.0/0 md5
  - host all all 0.0.0.0/0 md5

  users:
    admin:
      password: admin
      options:
        - createrole
        - createdb

postgresql:
  listen: postgres1112:5432
  connect_address: postgres1112:5432
  proxy_address: postgres1112:6432
  data_dir: /var/lib/postgresql/12/main
  bin_dir: /usr/lib/postgresql/12/bin
  pgpass: /tmp/pgpass
  authentication:
    replication:
      username: replicator
      password: replicator
    superuser:
      username: postgres
      password: postgres
    rewind:
      username: rewind
      password: rewind

tags:
    nofailover: false
    noloadbalance: false
    clonefrom: false
    nosync: false

# pgbouncer - postgres1112 Settings.
docker exec -it postgres1112 bash -c "nano /etc/pgbouncer/pgbouncer.ini"
* = host=postgres1112 port=5432 dbname=postgres
listen_addr = *
auth_user = pgbouncer
auth_query = SELECT p_user, p_password FROM public.lookup($1)

# ------------------------------------
# postgres1113 Settings.
# ------------------------------------
docker exec -it postgres1113 bash -c "nano /etc/hosts"
192.168.3.101   postgres1111
192.168.3.102   postgres1112
192.168.3.103   postgres1113

docker exec -it postgres1113 bash -c "mv /etc/default/etcd /etc/default/etcd-orig"
docker exec -it postgres1113 bash -c "nano /etc/default/etcd"
ETCD_NAME=postgres1113
ETCD_DATA_DIR="/var/lib/etcd/postgres1113"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.3.103:2380"
ETCD_INITIAL_CLUSTER="postgres1111=http://192.168.3.101:2380,postgres1112=http://192.168.3.102:2380,postgres1113=http://192.168.3.103:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"
ETCD_ENABLE_V2="true"

# Patroni - postgres1112 Settings.
docker exec -it postgres1113 bash -c "nano /etc/patroni/postgres.yml"
scope: pg_cluster
namespace: /service/
name: postgres1113

restapi:
    listen: postgres1113:8008
    connect_address: postgres1113:8008

etcd:
    hosts: postgres1111:2379,postgres1112:2379,postgres1113:2379

bootstrap:
  dcs:
    ttl: 30
    loop_wait: 10
    retry_timeout: 10
    maximum_lag_on_failover: 1048576
    postgresql:
      use_pg_rewind: true
      use_slots: true
      parameters:

  initdb:
  - encoding: UTF8
  - data-checksums

  pg_hba:
  - host replication replicator 127.0.0.1/32 md5
  - host replication replicator 0.0.0.0/0 md5
  - host all all 0.0.0.0/0 md5

  users:
    admin:
      password: admin
      options:
        - createrole
        - createdb

postgresql:
  listen: postgres1113:5432
  connect_address: postgres1113:5432
  proxy_address: postgres1113:6432
  data_dir: /var/lib/postgresql/12/main
  bin_dir: /usr/lib/postgresql/12/bin
  pgpass: /tmp/pgpass
  authentication:
    replication:
      username: replicator
      password: replicator
    superuser:
      username: postgres
      password: postgres
    rewind:
      username: rewind
      password: rewind

tags:
    nofailover: false
    noloadbalance: false
    clonefrom: false
    nosync: false

# pgbouncer - postgres1113 Settings.
docker exec -it postgres1113 bash -c "nano /etc/pgbouncer/pgbouncer.ini"
* = host=postgres1113 port=5432 dbname=postgres
listen_addr = *
auth_user = pgbouncer
auth_query = SELECT p_user, p_password FROM public.lookup($1)

# ------------------------------------
# ETCD Settings.
# ------------------------------------
docker exec -it postgres1111 bash -c "service etcd start"
docker exec -it postgres1112 bash -c "service etcd start"
docker exec -it postgres1113 bash -c "service etcd start"
docker exec -it postgres1111 bash -t -c "etcdctl member list"
docker exec -it postgres1111 bash source /etc/environment
etcdctl endpoint status --write-out=table --endpoints=$ENDPOINTS
exit

# Patroni Settings.
docker exec -it postgres1111 bash -c "service patroni start"
docker exec -it postgres1111 bash -c "tail -f /var/log/patroni.log"

docker exec -it postgres1112 bash -c "service patroni start"
docker exec -it postgres1113 bash -c "service patroni start"
source /etc/environment
patronictl list
exit

# pgbouncer Settings.
docker exec -it postgres1111 bash -c "psql -h postgres1111 -p 5432 -U postgres"
CREATE ROLE pgbouncer LOGIN with encrypted password "TypeYourPasswordHere";

CREATE FUNCTION public.lookup (
	INOUT p_user     name,
	OUT   p_password text
) RETURNS record
LANGUAGE sql SECURITY DEFINER SET search_path = pg_catalog AS
$$SELECT usename, passwd FROM pg_shadow WHERE usename = p_user$$;

CREATE ROLE pgbouncer LOGIN with encrypted password "TypeYourPasswordHere";

CREATE FUNCTION public.lookup (
	INOUT p_user     name,
	OUT   p_password text
) RETURNS record
LANGUAGE sql SECURITY DEFINER SET search_path = pg_catalog AS
$$SELECT usename, passwd FROM pg_shadow WHERE usename = p_user$$;

select * from pg_shadow;

\q


docker exec -ti postgres1111 bash -c "nano /etc/pgbouncer/userlist.txt"
"pgbouncer" "PasteEncryptedPasswordHere"

docker exec -it postgres1111 bash -c "service pgbouncer start"
docker exec -it postgres1112 bash -c "service pgbouncer start"
docker exec -it postgres1113 bash -c "service pgbouncer start"

docker exec -ti postgres1111 bash -c "psql -h postgres1111 -p 6432 -U postgres"

docker exec -ti postgres1112 bash -c "psql -h postgres1111 -p 6432 -U postgres"
docker exec -ti postgres1113 bash -c "psql -h postgres1 -p 6432 -U postgres"


# haproxy1 Settings.
docker create -it --network pg_network --ip 192.168.3.100 -h haproxy1 -p 5000:5000 -p 5001:5001 -p 7000:7000 --name haproxy1 ubuntu:20.04

docker start haproxy1

docker exec -it haproxy1 bash -c "apt update; apt install -y haproxy nano"

docker exec -it haproxy1 bash -c "mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.orig"
docker exec -it haproxy1 bash -c "nano /etc/haproxy/haproxy.cfg"
global
     log 127.0.0.1   local2
     chroot /var/lib/haproxy
     stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
     stats timeout 30s
     user haproxy
     group haproxy
     maxconn 100
     daemon

defaults
    mode                    tcp
    log                     global
    option                  tcplog
    retries                 3
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout check           10s
    maxconn                 100

listen stats
    mode http
    bind *:7000
    stats enable
    stats uri /

listen primary
    bind *:5000
    option httpchk OPTIONS /master
    http-check expect status 200
    default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
    server postgres1 192.168.02.10:6432 maxconn 100 check port 8008
    server postgres1112 192.168.02.10:6432 maxconn 100 check port 8008
    server postgres1113 192.168.02.12:6432 maxconn 100 check port 8008

listen replicas
    bind *:5001
    balance roundrobin
    option httpchk OPTIONS /replica
    http-check expect status 200
    default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
    server postgres1 192.168.02.10:6432 maxconn 100 check port 8008
    server postgres1112 192.168.02.10:6432 maxconn 100 check port 8008
    server postgres1113 192.168.02.12:6432 maxconn 100 check port 8008

docker exec -ti haproxy1 bash -c "service haproxy start"


# HA Test Ubuntu.
sudo apt install -y postgresql-client python3-psycopg2

echo "localhost:5000:*:postgres:postgres" >> ~/.pgpass
echo "localhost:5001:*:postgres:postgres" >> ~/.pgpass
chmod 0600 ~/.pgpass

psql -h localhost -p 5001 -U postgres -t -c "select inet_server_addr()"

psql -h localhost -p 5001 -U postgres -t -c "select inet_server_addr()"

psql -h localhost -p 5000 -U postgres -t -c "select inet_server_addr()"

psql -h localhost -p 5000 -U postgres -c "create database testdb;"
psql -h localhost -p 5000 -U postgres -c "create user testuser with encrypted password 'TypeYourPassword';"
psql -h localhost -p 5000 -U postgres -c "grant all privileges on database testdb to testuser;"

echo "localhost:5000:*:testuser:TypeYourPassword" >> ~/.pgpass
echo "localhost:5001:*:testuser:TypeYourPassword" >> ~/.pgpass
psql -h localhost -p 5000 -U testuser -d testdb -c "CREATE TABLE logbook (guest_email text, guest_id serial, date timestamp, message text);"
psql -h localhost -p 5000 -U testuser -d testdb -c "INSERT INTO logbook (guest_email, date, message) VALUES ('guest1@emailaddress.com', current_date, 'This is just to test database replication.');"

psql -h localhost -p 5001 -U testuser -c "select * from logbook,inet_server_addr();"

psql -h localhost -p 5001 -U testuser -c "select * from logbook,inet_server_addr();"

git clone https://github.com/manwerjalil/pgscripts.git
chmod +x ~/pgscripts/pgsqlhatest.py

nano ~/pgscripts/pgsqlhatest.py
host = "TypeHAProxyIPHere"
password = "TypeYourPassswordHere"

psql -h localhost -p 5000 -U postgres -c "CREATE TABLE PGSQLHATEST (TM TIMESTAMP);"
psql -h localhost -p 5000 -U postgres -c "CREATE UNIQUE INDEX idx_pgsqlhatext ON pgsqlhatest (tm desc);"

docker exec -it postgres1 bash
watch patronictl list
~/pgscripts/pgsqlhatest.py 5000
~/pgscripts/pgsqlhatest.py 5001

docker exec -it postgres1112 bash
patronictl failover --candidate postgres1112 --force
