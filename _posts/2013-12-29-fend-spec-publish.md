先日 [この記事][blog-koa-entry] で、ここ最近作っている [Fend.js][old-fend] という Web アプリケーションフレームワークを作っていることをお伝えしました。

改めて、仕様、設計方針について整理も兼ねて、spec を下記の github の repository にドキュメントとして公開しましたので、興味がある方は一読をどぞー。

- [fendjs/spec][fend-spec]

頭の中で考えていることをドキュメントにおとしただけなので、いろいろと荒削りで、これできんの？的なことがあると思いますが、実際に作りながら spec ブラッシュアップしていきたいと思います。


名称の変更
===========
先日のブログ記事の予告どおり、github の orgnaization を fendjs に変更しましたが、ついでに Webアプリケーションフレームワークの名称を **Fend.js** から **Fend** に変更しました(orgnaization が fendjs なのは、既に fend が使われているため)。

〜.js というのは何かありきたりだし、個人的にはクライアント側のみのフレームワークをイメージがあるし。なので **Fend** という .js がつかない名称に変更しました。

これまで作ったものについて
==========================
これまで作った関連モジュールとして以下があります。

- [fendjs-model][fendjs-model]
- [fendjs-model-restful][fendjs-model-restful]
- [fendjs-model-mongo][fendjs-model-mongo]
- [fendjs-route][fendjs-route]
- [fendjs-router][fendjs-router]
- [fendjs-router-server][fendjs-router-server]
- [fendjs-collection][fendjs-collection]

これらは、移行できるものは、新しい fendjs の orgnaization の方に移行する予定です。

なぜ作っているのか
==================
これについて、知りたい方がいると思うので、背景的なことをこのブログ記事で書いておきたい思います。

なぜ、作っているのかというと、それは、クライアントサイドとサーバサイド、どちらともシームレスに対応できて、柔軟に DB や API そしてバックエンドとアクセス可能な、Web アプリケーションを開発できる自分好みの Web アプリケーションフレームワークがなかったから、ということに尽きます。

Node を使ったWebアプリケーション開発の現状
------------------------------------------
[Connect][connect]、[Express][express]、最近でてきた [Koa][koa] といったフレームワークは、Node 環境で Web アプリケーションを作るためのサーバサイドのフレームワークです。

[Backbone.js][backbone]、[Ember.js][ember]、そして最近はやりの[Angular.js][angular]といった MVC なフレームワークは、ブラウザ環境で動作するクライアントサイドの Web アプリケーションを作るためのフレームワークです。

通常、Node を使ってモダンでインタラクティブな UX を備えた Web アプリケーションを作る場合、これらクライアントサイド、サーバサイドのフレームワークを利用して開発することになるかと。

Node 案件での開発経験
----------------------
以前に Node を使ったの案件で Web サービスの開発のお手伝いをさせて頂きました。お手伝いした案件では、iOS アプリで使っていたバックエンドがあり、そのバックエンドは MongoDB にアクセスしてゴニュゴニョいろいろビジネスロジックを実行して結果を JSON でレスポンスを返すという、今流行の API サーバ的なものでした。

Web サービスの開発も引き続き、そのバックエンドを使って開発していったのですが、当時は [Rendr][rendr]、[Ezel][ezel] のようなクライアントサイド、サーバサイド、どちらでもレンダリングしてうまく動作してくれるものがありませんでした(Ezel を作った Artsy の[エンジニアブログ][ezel-blog]の記事で、[Derby][derby] というのが大分前からあることを知った。。。orz)。なので Express と Backbone を使って開発していったのですが、テンプレートをクライアントとサーバで共有する仕組みを自前で実装したりと、SEO に対応できるようにしたりレンダリング関連でいろいろと苦労しました。

また、この開発においては、Rails のようにプロジェクトファイルを作成する generator や 開発の Rail がしかれているわけではないので、プロジェクトのディレクトリ構造の説明や開発手順をマニュアルとしてドキュメントにおこしたりと、Web サービス開発の本質的ではないコミュニケーションコストにより、時間のロスが発生していました。

こういった経験により、Rail が敷かれた、うまくクライアントサイドとサーバサイドをシームレスに開発できるWebアプリケーションフレームワークが欲しいなあと思うようになっていたのでした。

最近でてきた Rendr
------------------
[東京Node学園祭2013][node-fest2013]の[@mshk][twitter-mshk]さんの[セッション][node-fest-session-rendr]で知った Rendr ですが、Rendr はフレームワークではなく、あくまでも Express + Backbone をベースとした、クライアントサイド、サーバサイド、どちらでもレンダリングを行うためのライブラリです(Rendr については[id:koichik][id:koichik]さんの記事が分かりやすいです)。

Rendr 何か良さそうだなあと思って、実際に動かしたり、コード読んだりしていろいろと調べていったのですが、

- MySQL、MongoDB などといったデータベースアクセスや、TCP によるバックエンドへのアクセスは自前でカスタムな DataAdapter を実装する必要がある
- Model に対するビジネスロジックの実装は、気をつけないとクライアントに配信された JavaScript コードを読まれてクラック、いたずらされる
- Express と Backbone をベースにして実装しているので、それぞれのフレームワークのクセで、Rendr の拡張がしづらそうだ
- 何かコードがきたない

ということが分かり、Rendr は自分が望んでいるのとはちょっとこれは違う感じだということが判明。

というわけで
------------
こうした背景から、いつまで経ってもクールなものが出てきそうにないので、ないなら作っちゃえ！っていうノリで作り始めたのでした。



[blog-koa-entry]: http://blog.kazupon.jp/post/71041135220/koa
[fend-spec]: https://github.com/fendjs/spec
[fend]: https://github.com/fendjs/fend
[old-fend]: https://github.com/Frapwings/fend.js
[fendjs-model]: https://github.com/Frapwings/fendjs-model
[fendjs-model-restful]: https://github.com/Frapwings/fendjs-model-restful
[fendjs-model-mongo]: https://github.com/Frapwings/fendjs-model-mongo
[fendjs-route]: https://github.com/Frapwings/fendjs-route
[fendjs-router]: https://github.com/Frapwings/fendjs-router
[fendjs-router-server]: https://github.com/Frapwings/fendjs-router-server
[fendjs-collection]: https://github.com/Frapwings/fendjs-collection
[connect]: http://www.senchalabs.org/connect/
[express]: http://expressjs.com
[koa]: http://koajs.com
[backbone]: http://backbonejs.org
[ember]: http://emberjs.com
[angular]: http://angularjs.org
[rendr]: https://github.com/airbnb/rendr
[ezel]: http://ezeljs.com
[derby]: http://derbyjs.com
[ezel-blog]: http://artsy.github.io/blog/2013/11/30/rendering-on-the-server-and-client-in-node-dot-js/
[node-fest2013]: http://nodefest.jp/2013/
[node-fest-session-rendr]: http://www.slideshare.net/mshk/rendr
[twitter-mshk]: https://twitter.com/mshk
[id:koichik]: http://d.hatena.ne.jp/koichik/20131207
