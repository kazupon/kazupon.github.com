---
tags: よもやま
format: markdown
slug: 2015-in-review
title: 2015 年を振り返ってみる
type: text
--

2015 年を振り返ってみました。

# 書いたコードの数字
我らソフトウェアエンジニア、コード書いてなんぼなので書いたコードの数字で振り返ってみました。まずは、トータルの結果から。

| コミット数 | 追加行数 | 削除行数 | 編集行数 (追加+削除) |
| -------------:| -------------:| -----:| ------:|
| 2082 | 403112 | 148338 | 551450 |

追加、削除を合わせて編集行数としては，だいだい 55 万ってところですね。

![](http://kazupon.github.com/images/20151230_editline.png)

フリーザ様の戦闘力を越えたところといった感じでしょうか。仕事と OSS (プライベート) でちょっとブレイクダウンしてみましょう。

## 仕事で書いたコードの数字
仕事で書いたコード数はこんな感じになります。

- 2015 年に仕事で書いたコード数

| コミット数 | 追加行数 | 削除行数 | 編集行数 (追加+削除) |
| -------------:| -------------:| -----:| ------:|
| 1249 | 319333 | 83926 | 403259 |

比較のため、2014 年に書いたコード数も載せておきます。

- 2014 年に仕事で書いたコード数

| コミット数 | 追加行数 | 削除行数 | 編集行数 (追加+削除) |
| -------------:| -------------:| -----:| ------:|
| 1193 | 101836 | 50650 | 152486 |

前年度と比べると3倍近く書いてますね。今年はいろいろと機能等指向錯誤したりここ最近の方向転換で、狂ったようにコード書いたからなあ。コミット数が去年とそんなに変わらないのに、追加行数が大体3倍になっているのは、その徴候が現れている成果だと思います。

## OSS / プライベートで書いたコードの数字
次に今年のOSSで貢献する際に書いたコード数を見てみましょう。こんな感じになります。

| リポジトリ | コミット数 | 追加行数 | 削除行数 | 編集行数 (追加+削除) |
| ---------- | -------------:| -------------:| -----:| ------:|
| [vuejs/vue-validator][vue-validator] | 304 | 19184 | 21670 | 40854 |
| [vuejs/vue][vue] | 8 | 120 | 74 | 194 |
| [vuejs/vuejs.org][vuejs.org] | 21 | 54 | 34 | 88 |
| [vuejs/vue-router][vue-router] | 59 | 1579 | 403 | 1982 |
| [vuejs/vuex][vuex] | 18 | 1226 | 255 | 1481 |
| [vuejs/awesome-vue][awesome-vue] | 4 | 11 | 1 | 12 |
| [vuejs/jp.vuejs.org][jp.vuejs.org] | 290 | 33310 | 32099 | 65409 |
| [vuejs-jp/discussion][discussion] | 5 | 19 | 5 | 24 |
| [vuejs-jp/home][home] | 4 | 29 | 0 | 29 |
| [dekujs/deku][deku] | 1 | 1 | 1 | 2 |
| [yyx990803/semi][semi] | 2 | 10 | 6 | 16 |
| [kazupon/vue-i18n][vue-i18n] | 76 | 11591 | 9436 | 21027 |
| [kazupon/vue-plugin-boilerplate][vue-plugin-boilerplate] | 30 | 1189 | 425 | 1614 |
| [kazupon/vue-define-reactive-demo][vue-define-reactive-demo] | 1 | 139 | 0 | 139 |
| [kazupon/vue-server-express-demo-example][vue-server-express-demo-example] | 3 | 362 | 1 | 363 |
| [kazupon/vue-router-hackernews][vue-router-hackernews] | 7 | 14955 | 2 | 14957 |
| 計 | 833 | 83779 | 64412 | 148191 |

コミット数 833 、編集コード行数148191 。前年度のデータすぐに出せないのであれですが、今年2015年は、Vue.js 関連プロジェクト(`vuejs.org`/`vue-router`/`vuex`)の翻訳とか、[Vue.js の orgnaization](https://github.com/vuejs) の一員として `vue-validator` のメンテ・開発、個人の `vue-i18n` の Vue.js 1.0 対応 とかで、相当コード書いたので、この数字は前年度の数値で比較せずとも、実感している感じです。


# GitHub の草
次に GitHub の草 こと contributions を見てみましょう。

public 版の表示はこんな感じです。

- public contributions

![](http://kazupon.github.com/images/20151230_public_contributions.png)

仕事の private なものが入ったものはこんな感じになります。

- public + private contributions 

![](http://kazupon.github.com/images/20151230_contributions.png)

濃い色の部分と public のみの草と比較しながら見ると、どこで仕事のコードいっぱい書いたかどうかすぐに分かりますね。2月〜7月まで濃い部分が多いので、この辺り確かにガリガリコード書いてデプロイしてたなあ。まあこの状況は今も変わりませんが。

public の方では、5月以降草が多くなっています。これは、[Vue.js の orgnaization](https://github.com/vuejs) の一員として vue-validator のメンテ・開発していて活動はしていましたが、これに日本語公式サイトが入ってきたのが草の数が多くなった結果ですね。6月に [Vue.js 日本語版の公式サイト](http://jp.vuejs.org)を公開してから、逐次本家サイトの方が更新があると、すぐに日本語翻訳して日本語サイトの方にデプロイといった感じが、Vue.js 1.0 の公開まで続き、現状も引き続きという感じでしょうか。


# 勉強会での発表
以下 2 件。

## Railsで作られたサービスにVue.jsを導入したというお話
- イベント: [Vue.js Meetup](http://connpass.com/event/10862/)

<script async class="speakerdeck-embed" data-id="7e2dbf9570eb4ca883e6900b7f15cc68" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

## Next Vue.js 0.12
- イベント: [Data Binding JS Night](http://vuejs-meetup.connpass.com/event/14017/)
<script async class="speakerdeck-embed" data-id="9e491a4343094566945e3d661970a542" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

少ない。。。来年は、勉強会発表はもっと多くしたいところです。


# 今年の総括
一言でいうと、仕事では **キャリアアップ** と OSS では **Vue.js** という感じでしょうか。

## キャリアアップ
今の会社には、肩書的にはリードアーキテクト的な役割として2014年1月に入社し、入社以降弊社サービス[cuusoo](https://cuusoo.com)のシステム全般の開発面で社内のエンジニアとリードしてきたんですが、2015年6月から体制が変わり、CTO になったことでしょうか。

まさに今進んでいるプロジェクトで、開発計画(ロードマップ)や予算計画、開発しているプロダクトのプライシング(価格設定)したり、お客様のところにいって色々とデモや働きかけをお願いしたりと。まさに、CTO 的な仕事しつつ、コードをガリガリ書いて感じです。

![](http://kazupon.github.com/images/20151230_cto.jpg)

## Vue.js
今年はついに Vue.js 1.0 (CodeName:Evangelion) がリリースされました:tada: 。Vue.js 1.0 のリリースは、公式サイト[vuejs.org](http://vuejs.org)のドキュメント1.0 の内容を Vue.js の作者[Evan氏](https://github.com/yyx990803)といっしょに連携しながら、日本語版公式サイト[jp.vuejs.org](http://jp.vuejs.org)をほぼ同時にリリースできたので、OSS プロジェクトとしてかなりエキサイトしたのを覚えています。GitHub の[トレンド](https://github.com/trending?l=javascript) や、[HackerNews](https://news.ycombinator.com)にもランクインしましたし。

![](http://vuejs.org/images/logo.png)

これについて振り返ってみると、事の始まりは [Vue.js Meetup](http://connpass.com/event/10862) のイベントを開催だったと思っています。このイベントのおかげで公式サイトの翻訳しようという話がでてきて、[翻訳プロジェクト](http://connpass.com/event/12361/) が立ち上がり、6月に日本語公式サイト jp.vuejs.org のサイト公開することができたので。改めて、翻訳に関わってくださった方に感謝でいっぱいです。


# 来年度
仕事面の方では引き続き CTO として今のプロジェクトを頑張っていこうと思います。これが成功すると面白いことになるのはもちろん、自分の思い描いている**テクノロジーカンパニーとしてエンジニアが幸せになれるような環境**を作っていけそうなので。

OSS の方は、今までどおりいろんな方面にアンテナを張りつつ、引き続き Vue.js の方にしていきたいと思います。自分が担当している `vue-validator` はもちろんのこと、vue 本体やエコシステム周りの方にもいろいろとコントリビュートしていきたいです。Evan 氏、日本の何かのイベントで呼べたらいいですね。

それでは、皆様、良いお年を。来年もよろしくお願いいたします。

[vue-validator]: https://github.com/vuejs/vue-validator
[vue]: https://github.com/vuejs/vue
[vuejs.org]: https://github.com/vuejs/vuejs.org
[vue-router]: https://github.com/vuejs/vue-router
[vuex]: https://github.com/vuejs/vuex
[awesome-vue]: https://github.com/vuejs/awesome-vue
[jp.vuejs.org]: https://github.com/vuejs/jp.vuejs.org
[discussion]: https://github.com/vuejs-jp/discussion
[home]: https://github.com/vuejs-jp/home
[deku]: https://github.com/dekujs/deku
[semi]: https://github.com/yyx990803/semi
[vue-i18n]: https://github.com/kazupon/vue-i18n
[vue-plugin-boilerplate]: https://github.com/kazupon/vue-plugin-boilerplate
[vue-define-reactive-demo]: https://github.com/kazupon/vue-define-reactive-demo
[vue-server-express-demo-example]: https://github.com/kazupon/vue-server-express-demo-example
[vue-router-hackernews]: https://github.com/kazupon/vue-router-hackernews
