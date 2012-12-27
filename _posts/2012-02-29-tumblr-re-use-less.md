---
state: published
tags: CSS,HTML,less,Tumblr
date: '2012-02-29 11:52:53 GMT'
format: markdown
slug: tumblr-re-use-less
title: lessのエスケープ機能を使えばTumblrでもよりデザインが簡単に
id: 18491057864
type: text
---
[前回][tumblr-use-less]のブログで、lessを使ってTumblrのテーマをカスタマイズするには、Tumblrのテンプレートのシンタックスとlessのシンタックスと相性が悪いため、

    $ cat style.less
    @mycolor: '__{color:Background}__';
    body {
        background: @mycolor;
    }

    $ lessc style.less
    body {
        background: '__{color:Background}__';
    }

    $ lessc style.less | sed -e s/\'__\{/\{/g -e s/\}__\'/\}/g > style.css

    $ cat style.css
    body {
        background: {color:Background};
    }


っていう何か七めんどくさいHackっぽいことで、Tumblrのテーマに適用可能なCSSを生成していたと思います。
が、実は、lessのエスケープ機能を使えば、簡単にできるっぽい。

    $ cat style.less 
    @main_bg_color: ~'{color:Background}';
    body {
        background: @main_bg_color;
    }

    $ lessc style.less 
    body {
        background: {color:Background};
    }

文字列の前にチルダ(`~`)をつければいいだけ。
これだけで、Tumblrのテーマのシンタックスにあう形のCSSを生成できるようになります。

このエスケープ機能、うーん、[1.1.0][less]のときに実装されていたんですね。。。ドキュメントの確認ってやっぱ大事ですわ。


[tumblr-use-less]: http://blog.kazupon.jp/post/18019302930/tumblr-use-less
[less]: https://github.com/cloudhead/less.js/commit/37a90c6765f2ae968af42dbafba4da4d2480861a
