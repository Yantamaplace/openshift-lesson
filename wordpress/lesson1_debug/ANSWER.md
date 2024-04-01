# lesson01 デバッグしてみる（答え合わせ）

以下内容の修正が必要。

| ファイル名 | 修正点 | 修正方法 |
| --- | --- | --- |
| mysql/mysql-secret.yaml | 平文からSecretを作る文言になっていない。 | 「data」を「stringData」にする。|
| mysql/mysql-service.yaml | 紐づけるアプリ名が間違っている。（wordpress-mysql）| appの記載を「wordpress-mysql」からmysql-deploymentのコンテナ名である「mysql」に変える |
| mysql/mysql-deployment.yaml | PVのアタッチをする記述がない。| answerを見てPVのアタッチをする記述（2か所）を追記する。|
| wordpress/wordpress-build.yaml | build元のイメージのリポジトリの指定がない | namespace: openshift と追記する。 |
| wordpress/wordpress-build.yaml | イメージストリームの記載がない | answerを参考にイメージストリームを記載する。 |
| wordpress/wordpress-deployment.yaml | イメージストリームのリポジトリの指定が自身のリポジトリになっていない | tak01から自身のリポジトリに変更する。|
| wordpress/wordpress-deployment.yaml | 環境設定のうち、URLの記載がrouterで指定したURLになっていない | routerで作成したURLに変更する。|
| wordpress/wordpress-service.yaml | TargetPortの設定が、Deploymentと異なる | TargetPortを8080に変更する |
| wordpress/wordpress-route.yaml | TargetPortの設定が、Deploymentと異なる。80番Portはセキュリティ上NG。 | TargetPortを8080に変更する |
