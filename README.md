# openshiftを使ってみよう
OpenShiftに触ってみて、アプリケーションをデプロイしてみよう。

## 準備
### 端末のセットアップ
まず、端末本体にVMware Player 17をインストールする。
https://customerconnect.vmware.com/jp/downloads/info/slug/desktop_end_user_computing/vmware_workstation_player/17_0

次に、Redhatカスタマーポータルから、RHEL9のISOイメージ（フルイメージ）をダウンロードして、VMware Player上でインストールする。
https://access.redhat.com/downloads/content/rhel

### 作業用のLinuxサーバのセットアップ

#### sudo設定
ログインユーザに対して、sudo設定を実施する。
RHELの場合は、Wheelグループに所属しているユーザはsudo権限が付与される設計となっている。

現状は、どのユーザもsudo権限がついていない。
```
[root@localhost ~]# cat /etc/group | grep wheel
wheel:x:10:
[asuka@localhost ~]$ id
uid=1000(asuka) gid=1000(asuka) groups=1000(asuka) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
```

いまログインしているユーザ（例：asuka）に、wheelグループに追加する。
```
[root@localhost ~]# usermod -a -G wheel asuka
[root@localhost ~]# cat /etc/group | grep wheel
wheel:x:10:asuka

(再度一般ユーザでログインしなおす）

[asuka@localhost ~]$ id
uid=1000(asuka) gid=1000(asuka) groups=1000(asuka),10(wheel) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

```

#### RHELのサブスクリプション登録

事前に、RedHat Development Programに登録しておく。
https://developers.redhat.com/?source=sso

次に、以下コマンドでサブスクリプション認証を実施する。
```
[asuka@localhost ~]$ sudo subscription-manager register
登録中: subscription.rhsm.redhat.com:443/subscription
ユーザー名: redhat_account@example.com
パスワード:
このシステムは、次の ID で登録されました: a613d20e-0123-4567-890abcdefghijkl
登録したシステム名: localhost.localdomain
```

#### podman-composeのインストール

次のコマンドを実行する。
```
[asuka@localhost ~]$ sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
リポジトリー 'codeready-builder-for-rhel-9-x86_64-rpms' は、このシステムに対して有効になりました。
[asuka@localhost ~]$ sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
サブスクリプション管理リポジトリーを更新しています。
[asuka@localhost ~]$ sudo dnf install podman-compose
[asuka@localhost ~]$ which podman-compose
/usr/bin/podman-compose
```

### gitのインストール
gitをインストールする。
```
[asuka@localhost ~]$ sudo dnf install -y git
[asuka@localhost ~]$ which git
/usr/bin/git
```


## OpenSihftのレッスンの準備
以下githubに、レッスンの各種資材が入っていますので、ダウンロードしてください。
```
git clone https://github.com/asubee/openshift-lesson
```
wordpressディレクトリ配下。
answerフォルダは正しいマニュフェスト。それ以外はレッスン用。詳細は各フォルダ配下に入っているREADMEを参照してください。


## OpenShiftへのログイン
OCコマンドで、以下コマンドをたたき、OpenShiftにログインする。
CLI oc login -u <ユーザ名> https://api.h6nreujn.eastus.aroapp.io:6443/
