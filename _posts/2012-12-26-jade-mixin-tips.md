---
state: published
tags: Jade,template
date: '2012-12-26 17:33:46 GMT'
format: markdown
slug: jade-mixin-tips
title: Jadeで便利なmixinの機能
id: 38877362879
type: text
---
[Jade][jade] に mixin というテンプレートをモジュール化する機能があるんだけど，Jade の [github][github] の issues 上で自分が探している機能が pull-request されていないかどうか探していたら，[ここ][mixin attributes] で mixin の面白い機能があったので，ちょっとブログに書いて共有してみる．


mixin のシンタックスシュガー
============================
通常 mixin は下記のように定義したら `mixin <name>[(arg1, arg2, ...)]` のように使う．

    //- msgboard define
    mixin msgboard(msg)
      p #{msg}

    //- use
    mixin msgboard('Hello World')

`+` を定義した mixin 名の前に書くだけで，わざわざ `mixin` というキーワードを指定しなくても利用することができる．

    +msgboard('The world !!')


mixin の block
===============
Jade の mixin にも Ruby の block のようなものがある．使い方はこんな感じ．

    mixin article(title)
      .article
        .article-wrapper
          h1= title
          if block
            block
          else
            p No content provided

上記コードは，記事のテンプレートとしてモジュール化した mixin サンプル．至って普通な mixin なテンプレートコードなんだが，`block` というキーワードが使われていることが分かると思う．

このサンプルでは，`block` あるかどうか `if` でチェックして，あったら `block` 内容で置換し，ない場合は，`p` タグでコンテンツがないよ！的なもので配置するようにしてる．

この mixin は以下のようにして使うことができる．

    //- (1)
    +article('Hello world')

    //- (2)
    +article('The ') World !!

    //- (3)
    +article('Hello world')
      p This is my
      p Amazing article

初めの(1)の mixin は説明するまでもないが，普通の mixin 使い方．

(2)はパラメータの後に，テキストを指定している．スペース` `の後に指定したテキストが block として mixin に暗黙的に渡される．

(3)では，普通に Jade でタグを指定しているが，これも block として mixin に暗黙的に渡される．

上記を Jade でコンパイルすると以下のような，HTML が生成される．

<pre class="prettyprint linenums">
&lt;!-- (1) --&gt;
&lt;div class="article"&gt;
  &lt;div class="article-wrapper"&gt;
    &lt;h1&gt;Hello world&lt;/h1&gt;
    &lt;p&gt;No content provided&lt;/p&gt;
  &lt;/div&gt;
&lt;/div&gt;

&lt;!-- (2) --&gt;
&lt;div class="article"&gt;
  &lt;div class="article-wrapper"&gt;
    &lt;h1&gt;The &lt;/h1&gt;World !!
  &lt;/div&gt;
&lt;/div&gt;

&lt;!-- (3) --&gt;
&lt;div class="article"&gt;
  &lt;div class="article-wrapper"&gt;
    &lt;h1&gt;Hello world&lt;/h1&gt;
    &lt;p&gt;This is my&lt;/p&gt;
    &lt;p&gt;Amazing article&lt;/p&gt;
  &lt;/div&gt;
&lt;/div&gt;
</pre>


mixin の attributes
===================
a タグの href といった HTML のタグに属性があるように，mixin にも属性を設定するような機能がある．

どんなものかは，まずは，mixin のコードを見てみよう．

    mixin centered
      .centered(class=attributes.class)
        block

上記コードは，`centered`クラスのdiv タグと，その子として，block が指定されていればそれが置き換えるmixin のテンプレートである．

class 属性には，`attributes.class` というものが指定されている．`attributes` は，Jade の mixin で定義された暗黙の属性値を持つオブジェクトである．そんでもって，class というのは class 属性である．

上記 mixin を利用するコードは以下のようになる．

    //- (4)
    +centered.bold Hello world

    //- (5)
    +centered.red
      p This is my
      p Amazing article

(4)で指定した `.bold` がクラス属性として mixin の `attributes` オブジェクトの `class` プロパティに暗黙に設定される，(5) は、`.red` がクラス属性として mixin の `attributes` オブジェクトの `class` プロパティに暗黙に設定されることになる，

上記(4)，(5)をコンパイルすると以下のような HTML になる．

<pre class="prettyprint linenums">
&lt;!-- (4) --&gt;
&lt;div class="centered bold"&gt;Hello world
&lt;/div&gt;

&lt;!-- (5) --&gt;
&lt;div class="centered red"&gt;
  &lt;p&gt;This is my&lt;/p&gt;
  &lt;p&gt;Amazing article&lt;/p&gt;
&lt;/div&gt;
</pre>


これまでの mixin の応用
=======================
さて，これまでの mixin の機能を応用すると以下のような mixin を書くことができる．

    mixin link
      a.menu(attributes)
        block

これは，a タグのテンプレートを link mixin として定義したもの．a タグの `attributes` を指定しているので，mixin を利用する際には，href のような属性を指定することができる．

利用するコードの例は以下な感じになると思う．

    +link.highlight(href="#top") Top
    +link#sec1.plain(href="#section1") Section 1
    +link#sec2.plain(href="#section2") Section 2

まるで a タグや div タグのような HTML のタグを書くような感覚で自分が定義した mixin を使えてしまうのである．素晴らしや．Jade の mixin ．

もちろん，従来の mixin 同様パラメータを指定することも可能．

    //- define
    mixin list(arr)
      if block
        .title
          block
      ul(attributes)
        each item in arr
          li= item

    //- use
    +list(['空条承太郎', '東方仗助', 'ジョルノ・ジョバーナ', '空条徐倫', 'ジョニィ・ジョースター', '東方定助'])(id='personList', class='person') 登場人物
    +list(['スター・プラチナ', 'クレイジー・ダイヤモンド', 'ゴールド・エクスペリエンス', 'ストーン・フリー', 'タスク', 'ソフト＆ウェット'])(id='standList', class='stand') スタンド


まとめ
=====
[github][github] のトップなところに載っていない[目立たない部分に載っていた][jade.md]，覚えると便利な mixin の機能を紹介しました．これを応用すると，まるで自分で作ったようなオレオレ的な独自タグを使ってモジュール化して，再利用可能なテンプレートをモジュール化することができます．

ぜひ，この機能を利用して素敵な Web アプリや Web サービスを作って頂ければいいかなと．


コード
=====
これまでに使ったコードは，いつも通り [gist][gist] に置いておきました．


[jade]: http://jade-lang.com/
[github]: https://github.com/visionmedia/jade
[mixin attributes]: https://github.com/visionmedia/jade/pull/617
[jade.md]: https://github.com/visionmedia/jade/blob/master/jade.md
[gist]: https://gist.github.com/4379815
