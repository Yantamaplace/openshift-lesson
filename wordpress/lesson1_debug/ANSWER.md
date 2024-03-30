# lesson01 デバッグしてみる（答え合わせ）

以下内容の修正が必要。

| ファイル名 | 修正点 | 修正方法 |
| --- | --- | --- |
| mysql/mysql-secret.yaml | 平文からSecretを作る文言になっていない。 | 「data」を「stringData」にする。|
| mysql/mysql-service.yaml | 紐づけるアプリ名が間違っている。（wordpress-mysql）| appの記載を「wordpress-mysql」からmysql-deploymentのコンテナ名である「mysql」に変える |
| mysql/mysql-deployment.yaml | PVのアタッチをする記述がない。| answerを見てPVのアタッチをする記述（2か所）を追記する。|



