# Dockerのimage作成の元になるファイル
# Docker Docsに基づき作成
FROM ruby:2.6.3

# 必要なパッケージのインストール
# （採用）Quickstart版
RUN apt-get update -qq && \
    apt-get install -y nodejs \
                      postgresql-client
# Qiita版：丁寧すぎるDocker
# RUN apt-get update -qq && \
#     apt-get install -y build-essential \ 
#                        libpq-dev \        
#                        nodejs           

# 作業ディレクトリを作成
RUN mkdir /haito_notice 
# 作業ディレクトリ名をAPP_ROOTに割り当てて、以下$APP_ROOTで参照
ENV APP_ROOT /haito_notice
# 作業ディレクトリに移動
WORKDIR $APP_ROOT

# ホスト側（ローカル）のGemfileをコピー
COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

# Gemfileのbundle install
RUN bundle install
# 作業ディレクトリを全てコピー
COPY ./ $APP_ROOT

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
# パーミッション（許可属性）を実行可能に変更
RUN chmod +x /usr/bin/entrypoint.sh
# 一番最初に実行するコマンド
ENTRYPOINT ["entrypoint.sh"]
# コンテナがリッスンするport番号
EXPOSE 3000

# Start the main process.
# イメージ内部のソフトウェア実行
# CMD ["rails", "server", "-b", "0.0.0.0"]