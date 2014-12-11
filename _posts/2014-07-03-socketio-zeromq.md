---
tags: socket.io, zeromq
format: markdown
slug: socket-io-zeromq
title: ZeroMQに対応したsocket.ioのモジュールを作ってみた
type: text
--
# Socket.IO MeetUp
まず、本題に入る前に。

昨日の[Socket.IO MeetUp](http://connpass.com/event/6911/) に行って来たのですが、socket.ioの作者 Guillermo Rauch 氏から直々に、socket.ioを作るに至った背景や、今後のsocket.ioの関連の話、それと今話題の MQTT と Socket.IO を使った話を聞くことができて、楽しかったです。

"Web 上の EventEmitter" というようなプラットフォーム的な感じで今後盛り上がるといいですね。 :)


# モチベーション
さて、本題。

ここ最近、

- Socket.IO 1.0 のリリース
- [東京Node学園13時限目](http://nodejs.connpass.com/event/6763/)での Socket.IO 1.0 に関する話
- そして今回のSocket.IO Meetup

ということで、いろいろと進化している Socket.IO に興味が湧いたので、[ZeroMQ](http://zeromq.org) で複数の Socket.IO サーバ間にメッセージをブロードキャストするためのモジュールを Node で作ってみました。(本当は、LTで発表したかったんですけど、ちょっと間に合いそうになかったので、今回はパスしました。>< )

Socket.IO Meetup でヒートアップした折角の機会なので、紹介したいと思います。


# 作ったモジュール
作ったのは、以下の3つ。

- [socket.io-zeromq](https://github.com/kazupon/socket.io-zeromq)
- [socket.io-zeromq-emitter](https://github.com/kazupon/socket.io-zeromq-emitter)
- [socket.io-zeromq-server](https://github.com/kazupon/socket.io-zeromq-server)

## socket.io-zeromq
socket.io-zeromq は socket.io-adapter を ZeroMQ で実装した adapter です。

この adapter により、ZeroMQ の pub/sub を実装したサーバと通信することができ、メッセージを複数の Socket.IO サーバに分散することがきるようになります。

## socket.io-zeromq-emitter
socket.io-zeromq-emitter は Socket.IO によってブラウザにイベントを送るための ZeroMQ で実装した emitter です。

socket.io-emitter も同じブラウザにイベントを送るための emitter ですが、こちらはサーバが Redis しか使えないので、新たにモジュールを ZeroMQ 向け専用に作りました。

## socket.io-zeromq-server
socket.io-zeromq-server は、ZeroMQ の pub/sub (正確にはxpub/xsub) で実装したサーバです。探せば ZeroMQ で pub/sub を備えたサーバは探せばありそう?ですが、今回はとりあえず動けばよかったので、自分で実装しました。

## イメージ
これらの作ったモジュール、ざっくり、どんな感じにメッセージがやり取りするのかイメージにするとこんな感じになります。

![](https://31.media.tumblr.com/598f02128dbe0f8ffd092b51001a91a9/tumblr_inline_n85g000h291qzcyta.png)


# 動作を確認できるサンプル
興味がある人のために、動作を確認できるサンプルも作って以下の Github のリンク先においてあります。

- [socket.io-zeromq-sample](https://github.com/kazupon/socket.io-zeromq-sample)


# 感想
久々に Socket.IO に触った自分でも adatper を作ることで Redis 以外でもメッセージを複数の Socket.IO サーバに分散できるものを作れるようになったのはすごいなあと思いました。それぞれのコードをみてもらえれば分かるんだけど、adapter と emitter は、100行前後で実装できました。Socket.IO の各ノードに対して pub/sub するサーバ側なんですけども、こちらは今回は特に手抜きで作りましたが、実装次第では、Redis よりハイパフォーマンスなリアルタイムでスケーラブルなシステムを作れそうですね！:) 

いけてないなあと思ったのは、socket.io-emitter 。これクライアントの指定が Redis 縛りになってるので、adapter　のように抽象化してくれれば、socket.io-zeromq-emitter を作らなくてよかったかもしれないです。まあ、pub/sub 側のサーバが違うと、そのアーキテクチャによって違うから、勝手に emitter 作ってくださいというスタンスなのかもしれないし、昨日の話を聞いている感じだといろいろと事情、計画があって、わざとそうしているのかもしれないと勝手に予測。


# おわりに
いろいろと触ってみて、完成度がよいい感じで実践投入しても良さそうなので、今後、とりあえず適当に作った socket.io-zeromq-server 、まじめに実装したり、Engine.IO とかのちょいとレイヤが低い部分のコードやドキュメントを見ながら何か作って、きたる実戦投入に向けて Socket.IO とたわむれていこうと思います。

