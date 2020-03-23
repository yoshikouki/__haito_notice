# README

## 配当ノーティス Haito Notice

https://haito-notice.herokuapp.com


## 概略 OVERVIEW

配当ノーティスは、上場企業が公表している適時開示情報を収集・閲覧できるWebアプリケーションです。
現在は、ベータ版です。


## 特徴 FEATURES

このアプリでは、次のことができます。
- 最新の適時開示情報を確認できます。
- 企業別の適時開示情報を２〜３年前までの分を確認できます。
- 自分の興味のある企業をウォッチリストに登録できます。（ユーザー登録が必要です）
- ウォッチ中の企業が公表した適時開示情報をフィード表示できます。


## 使用方法 USAGE

```Terminal
$ git clone https://github.com/yoshikouki/haito_notice.git
$ cd haito_notice
$ bundle install --without production
$ rails db:create
$ rails db:migrate
$ rails s
>> http://localhost:3000
```

ブラウザでhttp://localhost:3000にアクセス。


## 環境 REQUIREMENT

- Ruby 2.6.3
- Rails 5.1.6


## AUTHOR

Yoshiko

エンジニアリングを勉強し始めた初学者です。
このアプリも勉強のために制作しております。

[Github](https://github.com/yoshikouki "Github")
[Twitter](https://twitter.com/K2_Yoshiko)


## 今後の予定 PLANS

- ユーザー機能をより充実させます
- 企業検索をより便利にします
- 適時開示情報をより早く表示できるように改善させます
- 適時開示情報をより柔軟に表示できるようにします
- ウォッチ中の企業が適時開示情報の公表した時にメールで通知します
- 適時開示情報の内容を簡易レポート形式で通知する機能を追加します（検討中）
- 企業の適時開示情報の内容を分析できる機能を追加します（検討中）

