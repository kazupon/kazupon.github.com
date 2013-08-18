---
state: draft
type: text
tags: component,template-engine,renderer
format: markdown
slug: component-render
title: component-render作ってみた
---

[component-render][component-render]という[component][component]のextensionを作ってみたので，ちょっと紹介したいと思う．


# component-renderって何?
component-renderはテンプレートファイルからHTMLファイルを生成する，componentのextensionツール．
component-renderではデフォルトでテンプレートエンジンとして`jade`を採用．後述するプラグインを作ることで，他のテンプレートエンジンを利用してcomponent-renderでHTMLファイルを生成することできる．


# インストール
以下のように`npm`で以下のようにインストール．

    $ npm install -g component-render

もちろん、componentが必要なのでインストールしておくこと．


# 使い方
基本的な使い方としては，テンプレートを指定して実行するだけ．

    # テンプレートの中味
    $ cat simple.jade
    p hello world

    # 実行
    $ component render simple.jade

    # 生成されたHTMLファイルの中味
    $ cat simple.html
    <p>hello world</p>

何らかのデータを想定して書かれたテンプレートから，データを与えてHTMLファイルを生成したい場合はこんな感じ．

    # テンプレートの中味
    $ cat user.jade
    p Name: #{name}
    p Job: #{job}

    # 喰わせるデータの中味
    $ cat user.json
    {
      "name": "kazupon",
      "job": "software engineer"
    }

    # 実行
    $ component render -l user.json user.jade

    # 生成されたHTMLファイルの中味
    $ cat user.html
    <p>Name: kazupon</p><p>Job: software engineer</p>

もちろん，mixinを利用したテンプレートもHTMLとして出力することができる．

    # mixinの中味
    $ cat mixin.jade
    mixin hello(msg)
      p hello #{msg}

    # ターゲットのテンプレートの中味
    $ cat include.jade
    include ./mixin

    +hello('world')

    # 実行
    $ component render include.jade

    # 生成されたHTMLファイルの中味の確認
    $ cat include.jade
    <p>hello world</p>

生成されるHTMLファイルの出力先は，`component render`を実行したカレントディレクトリに出力されるが，出力先・ファイル名をこんな感じにして出力することも可能．

    # 出力先を'./static/html/hoge.html'として指定して実行
    $ component render -o ./static/html/hoge.html simple.jade

    # 生成先の確認
    $ tree
    .
    ├── simple.jade
    └── static
        └── html
                └── hoge.html


# プラグイン
component-renderでは他のテンプレートエンジンを利用してHTMLファイルを生成できるようプラグインをサポートしている．
試しに筆者が作った[mustache][mustache]なテンプレートを[Hogan.js][hogan]でHTMLファイルを生成できるプラグイン[component-render-hogan][component-render-hogan]を利用する場合はこんな感じになる．

    # プラグインをインストールする
    $ npm install component-render-hogan

    # mustacheテンプレートの中味
    $ cat user.mustache
    {{#user}}
    <p>Name: {{name}}</p>
    <p>Job: {{job}}</p>
    {{/user}}

    # 喰わせるデータの中味
    $ cat user2.json
    {
      "user": {
        "name": "kazupon",
        "job": "software engineer"
      }
    }

    # 実行
    $ component render -u component-render-hogan -l user2.json user.mustache

    # 吐かれたHTMLファイルの中味
    $ cat user.html
    <p>Name: kazupon</p>
    <p>Job: software engineer</p>

とまあ，プラグインを作れば他のテンプレートエンジンを利用することもできる．プラグインの作り方は，[ここ][component-render]に載っているでそこを参照するべし．


# まとめ
まとめるまでもないけど，component-renderを利用するとテンプレートファイルからHTMLファイルを生成することができます．component-renderではテンプレートエンジンはデフォルトでjadeを採用していますが，プラグインをサポートしているので，他のテンプレートエンジンにも対応可能です．

このcomponentのextensionを利用すれば，サーバサイドからクライアントサイドへのアプリ開発のマイグレーションの手助けになるかもしれません．例えば，予めサーバサイドでレンダリングしていたものを事前にこのextensionでHTMLファイルとしてプリコンパイルして，staticなコンテンツしてNginxといったモダンなWebサーバでコンテンツとして配信して，動的なコンテンツの部分は昨今出てきているクライアントサイドベースのMVCフレームワークで開発するといったような．

ぜひ，componentを利用したWebアプリの開発に役立てればといいかなと思っています．


[component]: https://github.com/component/component
[component-render]: https://github.com/Frapwings/component-render
[component-render-hogan]: https://github.com/Frapwings/component-render-hogan
[hogan]: http://twitter.github.io/hogan.js/
[mustache]: http://mustache.github.io
