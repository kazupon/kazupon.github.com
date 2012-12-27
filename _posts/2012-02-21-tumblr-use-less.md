---
state: published
tags: Tumblr,HTML,CSS,less
date: '2012-02-21 18:42:54 GMT'
format: markdown
slug: tumblr-use-less
title: lessでTumblrのブログテーマをカスタマイズする
id: 18019302930
type: text
---
Tumblrでは、各ブログにある、[表示カスタマイズ] → [編集HTML] でテーマをカスタマイズすることができます。
カスタマイズにするに当たって、[ここ][customize]にある仕様というかTumblr独自のタグや変数を元にカスタマイズするわけですが、手がこんだデザインにしたい場合は、CSSをガリガリ書くことになるかと。

ただ、どんどんデザインの規模が大きくなってくると、CSSのコードがとんでもないことになり、[less][less]とか[sass][sass]といったCSS拡張したものを使いたくなるかと思います。
ここでは、愛用するlessでTumblrのブログのテーマのカスタマイズを試してみました。

# lessの利用形態の選定
lessの利用方法としては、

1. クライアント(ブラウザ)側で動的にCSSを生成する
2. サーバ側で動的にCSSを生成する
3. 静的なCSSを生成する

というパターンがあるかと。
それぞれのパターンについて簡単に説明すると、
1.は、headタグ内に

    <link rel="stylesheet/less" type="text/css" href="styles.less">
    <script src="less.js" type="text/javascript"></script>

という感じにすることで、lessファイルをlessのjavascritがコンパイルしてCSSを生成する方法。

2.は、クライアントからリクエストがあったときにサーバ(web)側でlessファイルを動的にCSSファイル(またはstyleタグ)を生成して、それをクライアント側に渡すという方法。
node.js (express) のコードを例にするとこんな利用イメージ。

    app.get('/', function (req, res) { // request handler
        fs.readFile('./style.less', 'utf-8', function (err, data) {
            var parser = new (less.Parser);
            parser.parse(data, function (e, tree) {
                res.send('<html><head><title>index</title><style>' + tree.toCSS() + '</style></head><body><h1>hello world</h1></body></heml>');
            });
        });
    });

3.は、lessファイルを`lessc`というコマンドによってCSSを生成し、それをCSSファイルかまたは、HTMLのstyleタグに設定して、従来どおりクライアントに渡すという方法。
`lessc`コマンドの基本的な使い方は、

    $ lessc style.less > style.css

という感じで、lessファイルを指定すると、CSSを出力するので、それをリダイレクトで保存するようにする。
ちなみに、less はミニファイもサポートしてて、`lessc`コマンドでは、

    $ lessc --compress style.less > style.css

という風に、`--compress`オプションを指定すると、ミニファイされたCSSが出力される。

1.〜3.のぞれぞれのメリット、デメリットについては調べたり、ちょっと考えれば分かると思うのでここでは説明しません。

で、Tumblrでは、どれでやったんだっていう話なんですが、3.でやりました。

2.についてはサーバ側でテーマのレンタリングをカスタマイズ仕組みがTumblrにはないのでどう考えてもあり得ません。
1.についてはTumblrでは、[ここ][upload]で静的ファイルをアップロードできるのですが、lessファイルはどう見ても対象外みたいなのでこれも使えません。
3.については設定でHTMLをガリガリカスタマイズできるので、styleタグに生成したCSSを設定できるので、必然的にこれになります。

# lessを使ってみたのだが。。。
[ここ][customize]にある内容を読んでみると分かると思うのですが、Tumblrでは独自のテンプレート?を使っているみたいで、なんかシンタックスが`{Title}`とか`{block:Text}{/block:Text}`とか[Mustache][Mustache]に似たものを使っています。

lessが従来のCSSと違って便利なものとして、変数があります。lessの変数は、

    @mycolor: #ff2233;

というような感じで使います。
Tumblrではテーマのカラー、フォントなどのカスタマイズをユーザーに提供する手段として、metaタグを使っており、カラー、フォント、画像などに対応する変数があります。
ですので、こういったCSSに関係する変数は、lessの変数としても使いたくなります。

ですが、ですが、Tumblrのテンプレートの変数は、

    {color:Background}

というようなシンタックスであり、lessが変数として扱うことができないので、非常に相性が悪いです。

    @mycolor: {color:Background};

のようにしても`lessc`コマンドではエラーになります。
何らかの方法でマッピングが必要になります。

# 回避方法
いろいろと考えた結果、Tumblrのテンプレートを変数を文字列としてlessの変数に設定することでこの問題に対応することにしました。

lessの変数は、文字列を扱えるので、`lessc`コマンドでCSSの生成が可能になります。そして、生成されたCSSを`sed`コマンドで置換することでTumblrで利用可能なCSSに仕上げます。

    $ cat style.less
    @mycolor: '__{color:Background}__';
    body {
        background: @mycolor;
    }

を、`lessc`コマンドを通すと、

    $ lessc style.less
    body {
        background: '__{color:Background}__';
    }

という風にCSSが出力されます。
これを下記のようにさらに、`sed`コマンドでフィルタすると

    $ lessc style.less | sed -e s/\'__\{/\{/g -e s/\}__\'/\}/g > style.css
    $ cat style.css
    body {
        background: {color:Background};
    }

となり、こちらで想定しているCSSが生成されるようになります。
    
# 実際にやってみる
では、実際にlessを使ってTumblrのカスタマイズをやってみましょう。ソースは、[gist][gist]から`git clone`してきましょう。

    $ git clone https://gist.github.com/1873913
    $ tree
    .
    |-- Makefile
    |-- style.less
    `-- template.html

## カスタマイズしたテンプレートを適用する
TumblrのブログのHTML編集で、template.htmlの内容を下記コマンド等でコピー&ペーストします。

    $ cat tempalte.html | pbcopy

ちなみに、`pbcopy`コマンドはMac OS Xで利用できるクリップボードにコピーするコマンドです。

## CSSをジェネレートしてテンプレートに適用する
`make`コマンドでCSSファイルをジェネレートします。

    $ make
    lessc ./style.less | sed -e s/\'__\{/\{/g -e s/\}__\'/\}/g > ./style.css
    lessc --compress ./style.less | sed -e s/\'__\{/\{/g -e s/\}__\'/\}/g > ./style.min.css

この`make`では、ミニファイ版(`style.min.css`)と通常版(`style.css`)のCSSファイルを`lessc`コマンドでコンパイル生成しています。

生成後、CSSファイルの内容を以下の画像のようにTumblerのテンプレートにコピー&ペーストします。今回はミニファイ版を使いたいと思います。

    $ cat style.min.css | pbcopy 

![][set_css]

CSSを適用すると以下のように右側のプレビューが変わると思います。

![][apply_css]

ちなみに、CSSを適用してもたまに変わらないときがあるみたい。なので、一旦表示のカスタマイズを閉じてから、再度カスタマイズのこの画面を開くと適用されているかどうか確認できます。

# まとめ
ちょっとした工夫(Hack)をすれば、Tumblrでもlessを使ってCSSでブログのデザインをすることができるようになりました。Tumblrではモバイル用の表示も設定すれば、iPhone(androidも?)に最適化してくれますが、このやり方を応用すれば、CSS3 Media Queries を使えば自分でレスポンシブWebデザインにも対応した、独自のテンプレートが作れるので面白いかもしれませんね！


[customize]: http://www.tumblr.com/docs/ja/custom_themes+
[less]: http://lesscss.org/
[sass]: http://sass-lang.com/
[Mustache]: http://mustache.github.com/
[upload]: http://www.tumblr.com/themes/upload_static_file
[gist]: https://gist.github.com/1873913
[set_css]: http://kazupon.github.com/images/20120222_set_css.png
[apply_css]: http://kazupon.github.com/images/20120222_apply_css.png
