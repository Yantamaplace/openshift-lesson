FROM redmine:5.1

# 環境変数の設定
ENV TZ Asia/Tokyo

# プラグインのコピー
#COPY ./redmine/redmine/plugins /usr/src/redmine/plugins

# テーマのコピー
COPY ./redmine/redmine/themes /usr/src/redmine/public/themes

# configurationファイルのコピー
COPY ./redmine/redmine/config/configuration.yml /usr/src/redmine/config/
#COPY ./redmine/redmine/config/gantt.rb /usr/src/redmine/lib/redmine/helpers/

# macros.rbファイルのコピー
COPY ./redmine/redmine/config/macros.rb /usr/src/redmine/lib/redmine/wiki_formatting/macros.rb

RUN chgrp -R 0 /usr/src/redmine && chmod -R g=u /usr/src/redmine
USER 1001
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE map[3000/tcp:{}]
CMD ["rails","server","-b","0.0.0.0"]
