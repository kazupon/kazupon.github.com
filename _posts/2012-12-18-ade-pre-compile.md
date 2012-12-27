---
state: published
tags: Jade,template
date: '2012-12-18 16:02:00 GMT'
format: markdown
slug: jade-pre-compile
title: Jadeテンプレートをクライアントサイドとサーバサイドで共有する
id: 38230033507
type: text
---
今ちょうど、Node を使ったあるプロジェクトで、[Express][express] 上でテンプレートエンジンとして [Jade][jade] を使ってWebサービスを作っているんだけど、サーバサイドとクライアントサイドでテンプレートを共有させる必要がでてきた。

サーバサイドとクライアントサイドでテンプレートの共有というと、[ここ][amd] のような [requires.js][requirejs] を使って動的に生成したものを共有したりなど、いろいろ素敵な方法がある。

こんなそんな風に既にあるものを使って共有してみてもいいんだけど、Jade のプリコンパイル機能で Javascript コードとして生成したものを static な \.js ファイルとして配信する方法で十分なので、それでやってみた。


共有するテンプレート
--------------------
共有するテンプレートのサンプルとしてはこんな感じ。

    mixin person(name, age)
      p.name Name: #{name}
      p.age Age:  #{age}

まあ、よくあるデータベースに登録されているユーザー情報を表示させるもの。このテンプレートは Jade の mixin 機能でテンプレートをモジュール化している。


サーバサイド、クライアントサイドで共有するための小細工
------------------------------------------------------
テンプレートをサーバ/クライアントサイドで共有するための更に小細工する。具体的には以下のように wrap したものを用意する。

    include ../mixins/person.jade

    mixin person(name, age)

こんな風に小細工するのは、mixin でモジュール化したものをプリコンパイルしただけでは、mixin モジュールを利用するコードが生成されないためだ。

なので、mixin でモジュール化したものを include してから、引き込んだ mixin モジュールにパラメータを渡して実行している。


テンプレートをプリコンパイルするスクリプト
------------------------------------------
クライアントでテンプレートを利用するために用意したテンプレートを以下のようなスクリプトでコンパイルする。

<pre class="prettyprint linenums">
'use strict';

var format = require('util').format;
var fs = require('fs');
var jade = require('jade');
var log = console.log.bind(console);
var error = console.error.bind(console);

// (1) クライアントで共有するプリコンパイルされたテンプレートのテンプレート
var js_template = [
  '(function (jade) {',
  '  var MyLib = this.MyLib || {};',
  '  MyLib.renderPerson = %s;',
  '  this.MyLib = MyLib;',
  '}).call(this, jade);'
].join('\n');


process.on('uncaughtException', function (err) {
  error(format('uncaughtException: %s', err.message));
  process.exit(1);
});


if (require.main === module) {
  fs.readFile('./views/includes/person.jade', 'utf8', function (err, template) {
    if (err) {
      error('Error: %j', err);
      process.exit(1);
      return;
    }
    // (2)
    // filename: プリコンパイル対象となるテンプレートはmixinをincludeしているのでこのオプションは必要
    // client: クライアントで利用するためにこのオプションも必要
    // compileDebug: デバッグ情報はいらないのでfalse
    template = jade.compile(template, {
      filename: './views/includes/person.jade', 
      client: true,
      compileDebug: false 
    });
    var js = format(js_template, template.toString());
    fs.writeFile('./public/javascripts/MyLib.personTemplate.js', js, function (err) {
      if (err) {
        error('Error: %j', err);
        process.exit(1);
        return;
      }
      process.exit(0);
    });
  });
}
</pre>

上記スクリプトでポイントとなるのはコメントで書いてある2箇所の部分。

(1)は、クライアント側でプリコンパイルされたテンプレートをライブラリのように利用するためのテンプレート。今回は、名前空間オブジェクト`MyLib`にプリコンパイルされたJavascriptコードをテンプレートのレンダリング関数として登録するようにしている。

(2)は、コメントにも書いてあるが、`jade.compile`関数のoptionとして、`filename`、`client`、`compileDebug`にそれぞれ適切な値を設定している。

上記スクリプトを `node` で実行すると、static な場所(このケースではexpressのデフォルト)に吐き出すようにしている。

クライアントで引き込むスクリプトファイルなので、[UglifyJS][UglifyJS] などでコードを minify するなど煮るなり焼くなりするなど好きなことができる。



プリコンパイルで生成されたテンプレートレンダリング関数を使う
------------------------------------------------------------
後は、普通にクライアント側の Javascript を書くように、生成したテンプレートレンダリング関数を以下のようなコードを書いて、head タグ等で script タグで引き込むようにするだけ。以下コード抜粋。

<pre class="prettyprint">
PersonView.prototype.render = function () {
  this.element.innerHTML = MyLib.renderPerson(this.model);
  return this;
};
</pre>

プリコンパイルされた Jade のテンプレートは、クライアントでも動作するよう作られた Jade の [runtime.js][runtime] が必要なので、static ところに配置するなどして配信するよう忘れずに。


まとめ
-----
Jade のプリコンパイル機能を利用すれば、サーバサイドとクライアントサイドでテンプレートを今回のような方法で予めプリコンパイルした状態で手軽に共有できます。テンプレートは Javascript にプリコンパイルされているので、レンダリングも高速でいいことづくめです。

テンプレートエンジンのプリコンパイル機能は、他のテンプレートエンジンにも搭載されていると思います。プリコンパイルができれば、このような方法で共有できると思うので、Node でサーバサイドで静的なコンテンツのレンダリング、クライアントサイドで動的なコンテンツのレンダリングに対応した Web サービス・Web アプリを作っててテンプレートの管理に困っている方は、ぜひ検討してみてはいかがでしょうか。


コード
-----
これまでのコードは、[gist][gist]に置いておきました。


[jade]: http://jade-lang.com/
[express]: http://expressjs.com/
[amd]: https://github.com/mysociety/node-jade-amd
[requirejs]: http://requirejs.org
[runtime]: https://github.com/visionmedia/jade/blob/master/runtime.js
[UglifyJS]: https://github.com/mishoo/UglifyJS/
[gist]: https://gist.github.com/4259804
