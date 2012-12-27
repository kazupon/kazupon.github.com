---
state: published
tags: tumblr,CLI,Ruby,tool
date: '2012-12-23 06:20:00 GMT'
format: markdown
slug: tumblr-rb-v2-api
title: tumblr-rb が tumblr API v2 に対応していた件
id: 38608373041
type: text
---
以前このブログのこの[記事][old blog] で `tumblr-rb` でコマンドでごにょごにょすることで、tumblr に投稿できると紹介したと思う。

あれから大分時間が経って、ついに Tumblr の v1 API が[廃止][tumblr-api-v1]になってしまった。以前使った時、みた感じ大分メンテナンスされていなかったので、もう `tumblr-rb` は使えんだろうと思っていのだが、改めて確認したみたところ、なんと最新版 `tumblr-rb` の 2.0.0 では [v2 API に対応している][tumblr-rb author]が判明した。

というわけで、試しに使ってみたので、前と若干使い方変わっていたり、パワーアップしていたので、それについて書いてみることにする。


前提条件
========
以前同様説明する必要はないかと思うが、`tumblr-rb` は Ruby で作られているので下記をインストールして置く必要がある。

- [Ruby][Ruby]
- [RubyGems][RubyGems]

まあ、`rvm` をインストールしていれば、`RubyGems` もインストールされるのそれをインストールした方が楽かもしれない。


インストール(アップデート)
==========================
まだ、`tumblr-rb`をインスコしていなれければ、下記コマンドでインストールする。

    $ gem install tumblr-rb

既にインストールしている人は、アップデートしてもいいと思う。


Authorize
==========
Tumblr v2 API からは OAuth での認証形式になっているので、新しい `tumblr-rb` でもそれに対応するため下記コマンドで Authorize する必要があるようだ。

    $ tumblr authorize

このコマンドを実行すると、下記のようにブラウザが立ち上がって、Tumblr で自分で適当にアプリ登録して、Comsumer key と Comsumer secret を入力して submit しろと言われる。

![][authorize1]

なので、表示されたページにアプリ登録のリンクが貼ってあるので、適当にアプリ登録しましょう。登録するときの注意点としては、説明する必要はないと思うが、 callback url を `http://localhost:4567` と登録しておく こと。じゃないと、Comsumer key と Comsumer secret を入力して submit しても、OAuth 認証完了後、callback されない。

OAuth が完了すると、下記のような画面が表示されるはずだ。

![][authorize2]

そう、Credential 情報は、$(HOME)/.tumblr に保存される。具体的は以下の様な OAuth の Credential 情報が保存されているはずだ。

    ---
    consumer_key: xxxxxxxx
    consumer_secret: yyyyyyyy
    token: zzzzzzzzzzzzzzz
    token_secret: aaaaaaaaaa

新しいバージョンでの `tumblr-rb` ではこれを使って Tumblr の API コールするというわけだ。

後は、指示に従って、Ctrl-C で 上記コマンドの終了させれば、Authorize は完了となる。


新しいバージョンでの使い方
==========================
新しい `tumblr-rb` では少し使い方がちょっと違う。具体的には

    $ tumblr COMMAND [OPTIONS] [ARGS]

のような使い方が必要。


post
----
Tumblr への投稿は 下記のような `post` コマンドで行う。

    $ tumblr post POST | FILE | URL

`POST` は 以前のバージョンと同様 YAML なメータデータ+ markdown で記載された[ここ][tumblr(5)]の形式なプレインテキストファイルを以下の例のように指定する。

    $ tumblr post ./hoge.txt

`FILE` もファイルを指定することで投稿することができる。拡張子がバイナリ形式の場合は、拡張子の中身に応じた形式でアップロードする。以下は画像ファイルの例。

    $ tumblr post ./foo.png

この画像ファイルの場合は、Photo 形式のブログ記事として投稿される。

`URL` は従来同様で、URLの内容に応じたブログ記事として投稿される。以下は、Youtubeの場合。

    $ tumblr post http://www.youtube.com/watch?v=CW0DUg63lqU

この場合は、ブログ記事は Video として扱われる。

従来同様パイプも可能。  

    $ cat data.yml my_post.txt | tumblr

ちなみに投稿が成功すると、Tumblr の POST ID が表示される。

    $ tumblr post http://www.google.com
    Post was successfully created! Post ID: 38561085439


delete
------
Tumblr への投稿したものを削除するには以下のようなコマンドを打つ。

    $ tumblr delete POST_ID

`POST_ID` は `post` とかで投稿したときに表示されたものや、個別記事URLの http://[username].tumblr.jp/post/xyz/slug に表示されたPOST ID (xyzの部分) を指定するればいい。


fetch
-----
Tumblr への投稿したものを下記コマンドで取得することができる。

    $ tumblr fetch POST_ID

例えばテキスト形式を取得するとこんな感じでレスポンスが返って来る。

    $ tumblr fetch 18000477386
    ---
    state: published
    tags: hogehoge
    date: '2012-02-21 06:56:00 GMT'
    format: markdown
    slug: ''
    title: テスト
    id: 18000477386
    type: text
    ---
    テスト
    sfsfldsfkl
    skfldsfjsf
    っっd

    ほげ
    fdslf


    edit
    ---

このコマンドは投稿した内容を確認するときは便利かも。

edit
----
Tumblr への投稿したものを下記コマンドでエディタで編集することができる。

    $ tumblr edit POST_ID

エディタは、環境変数、`$EDITOR` で指定しているエディタが起動する。このコマンド、ちょっとした間違いを修正するときに便利！

エディタで編集が完了すると、Tumblr にもアップデートされる。


オプション
==========
その他指定できるオプションとしては、以下な感じ。

-p, --publish
-------------
Tumblr への投稿を publish にする。YAML なメータデータで、state が draft とかにしていても無視される。

-q, --queue
-----------
Tumblr のキューに投稿する。

-d, --draft
-----------
Tumblr へ下書き状態として投稿する。


--credentials=PATH
------------------
OAuth な Credential 情報を指定する。$(HOME)/.tumblr にある Credential な OAuth キーを使いたくない場合とか便利かも。

--host=HOST
-----------
投稿先、Tumblr のブログを `xxxx.tumblr.com` の形式で指定する。複数ある場合は便利。

独自ドメインを設定している場合は、そのドメインを指定しないと、エラーになるので注意。


使ってみて思ったこと
====================
- edit コマンドが便利すぐる！
- 画像、音声、動画ファイルがアップロード出来るようになって便利

以前のバージョンで問題になっていたことが解決されていたので、新バージョンはかなりイケてると思う。PhotSets がサポートされたら、さらにイケてると思う。


リファレンス
===========
man ページがこれまでと同様 web 上にあるので、載せておきます。

- [tumblr(1)][tumblr(1)]
- [tumblr(5)][tumblr(5)]


[old blog]: http://blog.kazupon.jp/post/17929132848/tumblr-rb
[tumblr-api-v1]: http://developers.tumblr.com/post/28557510444/welcome-to-the-official-tumblr-developers-blog
[tumblr-rb author]: http://mwunsch.tumblr.com/post/34571571533/tumblr-cli-2
[Ruby]: http://www.ruby-lang.org/ja/
[RubyGems]: http://rubygems.org
[rvm]: https://rvm.io
[authorize1]: http://kazupon.github.com/images/20121223_tumblr_authorizing.png
[authorize2]: http://kazupon.github.com/images/20121223_tumblr_authorized.png
[tumblr(1)]: http://mwunsch.github.com/tumblr/tumblr.1.html
[tumblr(5)]: http://mwunsch.github.com/tumblr/tumblr.5.html
