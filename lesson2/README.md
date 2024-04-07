# Redmine
公式Dockerイメージに、プラグインやテーマなどを追加するDockerfile。リポジトリの中にあるファイルを、下記ディレクトリにコピーする。
1. redmine plugins(build/plugins -> /usr/src/redmine/plugins)
1. redmine public/themes(build/themes -> /usr/src/redmine/public/themes)
1. redmine config(build/config/configuration.yaml -> /usr/src/redmine/config/configuration.yaml)


# Dockerコンテナの起動方法
## データベースコンテナを作成する場合
podmanr-compose.ymlを実行する。
実行する前に、下記Volumeを作成しておくこと。

```
[asuka@localhost lesson2]$podman volume create redmine-db
redmine-db
[asuka@localhost lesson2]$podman volume create redmine-files
redmine-files
```

次に、podman-composeを実行する。途中で複数のリポジトリの中から使用するレジストリを選択する表示が出た場合は、dockerhubを選択する。
正常に立ち上がると、`podman-compose ps`で２つのコンテナが立ち上がっていることが確認できる。

```
[asuka@localhost lesson2]$ podman-compose -f podman-compose.yaml up -d
[asuka@localhost lesson2]$ podman-compose ps
podman-compose version: 1.0.6
['podman', '--version', '']
using podman version: 4.4.1
podman ps -a --filter label=io.podman.compose.project=lesson2
CONTAINER ID  IMAGE                             COMMAND               CREATED         STATUS         PORTS                   NAMES
10b52f9a4cdc  docker.io/library/mariadb:latest  mariadbd              19 seconds ago  Up 18 seconds                          lesson2_mariadb_1
e833569a9de4  localhost/lesson2_redmine:latest  rails server -b 0...  14 seconds ago  Up 14 seconds  0.0.0.0:3000->3000/tcp  lesson2_redmine_1
exit code: 0

```

次に、端末のFirewallの設定をする。上記の通り、端末の3000番のポートをコンテナの3000番ポートに紐づけている。そのため、firewall-cmdで3000番のtcpポートの許可設定を入れる。
```
[asuka@localhost lesson2]$ sudo firewall-cmd --add-port=3000/tcp --zone=public --permanent
success
uka@localhost lesson2]$ sudo firewall-cmd --reload
success
```



今使っている端末（RHEL）のIPアドレスを調べて、ブラウザでアクセスする。
```
[asuka@localhost lesson2]$ ip address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:0c:29:39:e3:86 brd ff:ff:ff:ff:ff:ff
    altname enp3s0
    inet 192.168.106.129/24 brd 192.168.106.255 scope global dynamic noprefixroute ens160
       valid_lft 1311sec preferred_lft 1311sec
```


