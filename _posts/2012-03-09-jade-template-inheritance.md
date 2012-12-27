---
state: published
tags: jade,template,node
date: '2012-03-09 17:32:00 GMT'
format: markdown
slug: jade-template-inheritance
title: Jadeのテンプレート継承を使ってみた
id: 19007475354
type: text
---
node.jsの数あるテンプレートエンジンのうち[Jade][jade]というのものがあり、[express][express]で使っているのですが、0.16辺りでテンプレート継承をサポートしてたみたいなので使ってみた。

#使い方
`extends`と`block`を使うことによってテンプレート継承を行う。

継承元となるテンプレートはこんな風に書く。ファイル名は `base.jade` としておく。

    //- base.jade
    !!! 5
    html
      head
        h1 My Site
        block scripts
          script(src="/jquery.js")
      body
        block header
          header
            p some header content
        block content
        block footer
          footer
            p some footer content

`block`には名前をつけることができる。このコード例は、Webサイトでよく見かけるレイアウトである、`header`、`content`、`footer`という風に名前を付けて、それぞれにHTMLのコンテンツを書いてある。`block`という書き方は、python の jinja や django を触ったことがある人には馴染みがある書き方であろう。

次にこの `base.jade` を継承したテンプレートはこんな感じになる。ファイル名は`extend.jade`としておく。

    //- extend.jade
    extends ./base

    block scripts
      script(src="/underscore.js")

    block content
      h1 title
      p hello world

継承するには`extends`に元となるテンプレートファイルのパスを指定する必要がある。このコード例では、このテンプレートファイルと同じカレントにあるパスを指定している。

`extends`の指定がすんだら、後は`block`のコードを書くだけ。継承元の`block`の内容を上書きしたい場合は、`block xxx`という風な感じで書いていくだけ。継承元の`block`の内容を上書きしない場合は継承先のテンプレートでは特にも何も記載しない。上記のテンプレートファイルを`jade`コマンドでHTMLファイルを生成するとファイルの中身はこんな風になる。

    $ jade -o {pretty:true} extend.jade 

      rendered extend.html

    $ cat extend.html
    <!DOCTYPE html>
    <html>
      <head>
        <h1>My Site
        </h1>
        <script src="/underscore.js"></script>
      </head>
      <body>
        <header>
          <p>some header content
          </p>
        </header>
        <h1>title
        </h1>
        <p>hello world
        </p>
        <footer>
          <p>some footer content
          </p>
        </footer>
      </body>
    </html>

`block header`、`block footer`は、`extend.jade`では上書きしていないので、`base.jade`の内容で。`block scripts`については、`extend.jade`の内容で上書き。そして`block content`については、`extend.jade`の内容で生成されていることが分かるかと思う。

jadeによるテンプレート継承の基本的な使い方はこんな感じ。

#append/prepend
jadeは基本上書きによるテンプレート継承なのだが、`block`の直後や直前に追加するようなテンプレート継承もできる。

ある`block`の直後に追加する継承は`append`を利用する。ここでのファイルは、`extend-append.jade`とする。

    //- extend-append.jade
    extends ./base

    block append scripts
      script(src="/underscore.js")

このコード例では、`scripts`に対してscriptタグを追加するようにしている。書き方としては、`block append xxx`という風な感じになる。これを実際に`jade`コマンドでHTMLファイルを生成するとこんな感じになる。

    $ jade -o {pretty:true} extend-append.jade 

      rendered extend-append.html

    $ cat extend-append.html
    <!DOCTYPE html>
    <html>
      <head>
        <h1>My Site
        </h1>
        <script src="/jquery.js"></script>
        <script src="/underscore.js"></script>
      </head>
      <body>
        <header>
          <p>some header content
          </p>
        </header>
        <footer>
          <p>some footer content
          </p>
        </footer>
      </body>
    </html>

`extend-append.jade`で書いた`block append scripts`の内容が`extend.jade`の`block script`に対して追加されていることが分かるかと思う。

逆に、ある`block`の直前に追加する継承は`prepend`を利用する。ここでのファイルは、`extend-prepend.jade`とする。

    //- extend-prepend.jade
    extends ./base

    block prepend scripts
      script(src="/underscore.js")

`extend-append.jade`の例と同じく、このコード例では、`scripts`に対してscriptタグを追加するようにしている。書き方としては、`block prepend xxx`という風な感じになる。これを実際に`jade`コマンドでHTMLファイルを生成するとこんな感じになる。

    $ jade -o {pretty:true} extend-prepend.jade 

      rendered extend-prepend.html

    $ cat extend-prepend.html
    <!DOCTYPE html>
    <html>
      <head>
        <h1>My Site
        </h1>
        <script src="underscore.js"></script>
        <script src="/jquery.js"></script>
      </head>
      <body>
        <header>
          <p>some header content
          </p>
        </header>
        <footer>
          <p>some footer content
          </p>
        </footer>
      </body>
    </html>

ちなみに、`append`/`prepend`を利用する場合は、`block`を省略することができる。

#継承元を利用しながら前後に対して拡張ができるかと思ったら。。。
この`append`と`prepend`を両方を使えば、jinja の `super`みたいに、継承元のコードを利用しつつ、その前後にコードを追加できるんじゃね？と思って、

    //- extend-both.js
    extends ./base

    block append scripts
      script(src="/underscore.js")

    block prepend scripts
      script(src="/hoge.js")

という風なコード書いてみて、できるかどうか確認したみたのだが、`jade`コマンドでHTMLファイルを生成してみると、生成されたファイルの中身確認してみると、

    $ jade -o {pretty:true} extend-both.jade 

      rendered extend-both.html

    $ cat extend-both.html
    <!DOCTYPE html>
    <html>
      <head>
        <h1>My Site
        </h1>
        <script src="/hoge.js"></script>
        <script src="/underscore.js"></script>
        <script src="/jquery.js"></script>
      </head>
      <body>
        <header>
          <p>some header content
          </p>
        </header>
        <footer>
          <p>some footer content
          </p>
        </footer>
      </body>
    </html>

とまあ、全然意図しない結果に。

うーん、`include`と`yield`でやるしかない感じかなあ。


#まとめ
- jadeでテンプレート継承は`extend`と`block`を使うことができる
- jadeでのテンプレート継承は基本上書き継承
- 既存のコードを利用しつつ、継承したい場合は、`append`/`prepend`を使う

#コード
これまでのコードは、[gist][gist]に置いておきました。


[jade]: http://jade-lang.com/
[express]: http://expressjs.com/
[gist]: https://gist.github.com/2007621
