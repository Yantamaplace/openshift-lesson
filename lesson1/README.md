# lesson01 デバッグしてみる
Wordpressをデプロイするマニュフェストを作成しました。
ですが、マニュフェストのうち何かが間違っていてうまくアプリが起動しません。原因を探ってください。

## 事前準備

OpenShiftにログインして、使いたいプロジェクトにログインしているかどうかを確認する。
```
[asuka@localhost lesson1_debug]$ oc whoami
ocurak0101
[asuka@localhost lesson1_debug]$ oc project
Using project "tak01" on server "https://api.h6nreujn.eastus.aroapp.io:6443".
[asuka@localhost lesson1_debug]$
```

次に、lesson1のフォルダに移動する。
```
[asuka@localhost ~]$ cd openshift-lesson/wordpress/lesson1_debug
[asuka@localhost lesson1_debug]$ ls
mysql  wordpress
[asuka@localhost lesson1_debug]$
```
mysql、wordpressそれぞれのマニュフェスト（yamlファイル）の中身を確認して、問題のある個所を修正する。
修正が終わったら、すべてのyamlファイルを登録する。


## 動作確認
以下観点で、動作確認をする。

* コンテナが正常に起動して、wordpressにアクセスできること
* コンテナを削除して、再度立ち上がってきたコンテナのデータのうち必要なデータが保存されていることを確認する（例：サイト名やユーザIDが保存されていることなど）

```
[asuka@localhost mysql]$ oc get pod
NAME                         READY   STATUS      RESTARTS   AGE
mysql-5b7cd9667c-bvb2d       1/1     Running     0          20m
wordpress-1-build            0/1     Completed   0          33m
wordpress-7487c6c977-v2lt9   1/1     Running     0          33m
[asuka@localhost mysql]$ oc delete pod mysql-5b7cd9667c-bvb2d
pod "mysql-5b7cd9667c-bvb2d" deleted
[asuka@localhost mysql]$ oc delete pod wordpress-7487c6c977-v2lt9
pod "wordpress-7487c6c977-v2lt9" deleted
```

