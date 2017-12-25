---
tags: vue.js vuejs vue
format: markdown
slug: 2017-vuejs-in-review
title: Vue.js 2017年まとめ & 今後
type: text
--

この記事は、[Vue.js #1 Advent Calendar 2017](https://qiita.com/advent-calendar/2017/vue)の25日目最後の記事です。

Vue.js 2.0 のリリースされた2016年10月から1年以上経過しました。今年はメジャーリリースは特にありませんでしたが、バグ対応、機能追加そして改善を通じて着実にのリリースを積み重ねて進化してきました。

この記事では、2017年の Vue.js 界隈における状況、出来事をまとめつつ、最後に Vue.js の今後について紹介して、4つもある Vue.js アドベンドカレンダの最後を締めくくりたいと思います。

# Stats
2017年 Vue.js はどうであったか。Stats を色々見ていきましょう。

まずは、`Google Trend` から。

![](https://kazupon.github.com/images/20171225_google_trend.png)

2016年と比較して、2017年は常に人気が高い状態が続いているのがわかります。

次に、`The State Of JavaScript` の Front-end の調査結果を見てみましょう。比較のために2016年のものを上げておきます。

![](https://kazupon.github.com/images/20171225_state_of_js_2016.png)

![](https://kazupon.github.com/images/20171225_state_of_js_2017.png)

2017年度の調査結果がパーセンテージで掲載されていないので、マウスオーバーで表示される数値を元に算出して2016年と比較すると以下のようになります。

- I've USED it before, and WOULD use it again (使ったことがあり、また使いたいか): 2016年10%、2017年20%
- I've HEARD of it, and WOULD like to learn it (聞いたことがあり、学習したいか): 2016年33%、2017年51%
- I've HEARD of it, and am NOT interested (聞いたことがあり、興味がない): 2016年34%、2017年22%

上記調査結果より、明らかに2016年に比べて知名度が高くなり、興味をもって学習したいというのがわかるでしょう。また、もう一度使いたいという満足度も伸びているのがわかります。

statsの最後として、`GitHub Stars` の状況を見ていきましょう。ここでも比較のために2016年のものを上げておきます。

![](https://kazupon.github.com/images/20161225_github_star.png)

![](https://kazupon.github.com/images/20171225_github_star_2017.png)

去年2016年と比べて、star される加速度が React に迫る勢いで伸びていることがわかります。

こうした stats の結果から、Vue.js は2017年は急激に知名度が高くなった年といえるでしょう。


# 4つのリリース
今年2017年、Vue.js は以下のように 2.x 系において、4つのマイナーバージョンのリリースをしました。

<script async class="speakerdeck-embed" data-slide="13" data-id="7d437d38c31b46318998d120b2d9c929" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

これらのリリースによって、いくつか機能されたり、改善されたりしましたが、これらリリースの中で注目すべきものとして以下のものになるでしょう。

- TypeScript の型定義の改善
- サーバサイドレンダリングの改善
- エラーハンドリングの改善
- SFCでの関数型コンポーネントのサポート

## TypeScript の型定義の改善
一番大きなものとしては v2.5 でリリースされた TypeScript の型定義の改善でしょう。

Vue.js の API はオブジェクトベースであるため、従来の TypeScript では `this` の型の推論は簡単ではなく、TypeScript を使って Vue.js で型の恩恵を受けるためには、`vue-class-component` とデコレータを利用して従来の Vue.js が提供する API と少し異なるものを利用しなければなりませんでした。

しかし、TypeScript の進化に伴いオブジェクトリテラルベースの型を理解できるようになったため、Vue.js のオブジェクトリテラルベースの API において型推論できるよう、型定義を改善することによって、`vue-class-component` のクラスベースの API とデコレータを使用せずとも、型推論が可能になりました。

同時に VSCode において [`vetur`](https://github.com/vuejs/vetur)拡張機能と同時に利用することによって、自動補完がかなり改善されることで、開発の生産性を高めることが可能になっており、他のエディタにおいても、`vue-language-server`によって language server protocol をサポートしていれば、VSCode + vetur と同等の恩恵を受けることが可能になっています。

![](https://cdn-images-1.medium.com/max/2000/1*ftKUpzYGIzn1eS87JcBS8Q.gif)

## サーバサイドレンダリングの改善
Vue.js 2.0 ではサーバサイドレンダリングをサポートしていますが、マイナーバージョンにリリースの度に改善を行う Evan 氏には目をみはるものがあります。

レンダラへ`template`オプション、`runInNewContext`オプションを新規追加によるサーバサイドレンダリングのレンダラの改善以外に、サーバサイドレンダリング向けに最適化されたwebpackプラグインの作成、prefetch による読み込み高速化、そして非同期コンポーネントをサポートや`vue-template-compiler`、`vue-loader`といった Vue.js コア本体、関連ライブラリにも最適化を施すことでかなりパフォーマンスの最適化を行っています。

サーバサイドレンダリングのパフォーマンス改善は、Nuxt.jsにも恩恵を与えており、Next.js とのパフォーマンスのベンチマークの[この騒動](https://github.com/zeit/next.js/issues/3201
)にも影響を与えるほどです。

さらに、v2.5 では、Node.js 以外の環境でもサーバサイドレンダリングできるよう対応し、PHP V8Js のような JavaScript 実行環境で動作できるようにクレイジーな対応をしています。興味ある方は[こちら](https://ssr.vuejs.org/ja/non-node.html)のドキュメントを参照しながら、試してみるとよいでしょう。

## エラーハンドリングの改善
マイナーバージョンのリリースによって、Vue.js におけるエラーハンドリングが改善されています。

v2.2 では、`Vue.config.errorHandler`オプションと、`renderError`コンポーネントオプションでエラーハンドリングできるよう改善しています。

`Vue.config.errorHandler`オプションは、アプリケーション内で発生した予期しないエラーを以下のようにハンドリングできるようになっています。

![](https://kazupon.github.com/images/20171225_errorhandler.png)

`renderError`コンポーネントオプションでは、`render`関数で発生したエラーをハンドリングして特別のレンダリング処理を以下のようできるようになっています。

![](https://kazupon.github.com/images/20171225_rendererror.png)

さらに、v2.5 で、さらにコンポーネント単位でエラーハンドリングできるよう、`errorCapture`フックが追加されています。これにより、以下のような子コンポーネントで発生したエラーをハンドリングするような汎用コンポーネントを作成することもできます。

![](https://kazupon.github.com/images/20171225_errorcaptured.png)

こうした、エラーハンドリングの対応により、Vue.js においてもより堅牢なアプリケーションを作成することが可能になっています。

## SFCでの関数型コンポーネントのサポート
Vue.js ではコンポーネントのレンダリングパフォーマンスを最大化するために、以下のような関数型コンポーネント(functional components)をサポートしています。

![](https://kazupon.github.com/images/20171225_functional_components.png)

v2.5 と vue-loader (v13.3.0 以降)によって、SFC(single file components: 単一ファイルコンポーネント)において、`<template>`ブロック内のテンプレートから以下のようにして、`render`関数でレンダリングするよう実装しなくても、テンプレートベースで関数型コンポーネントを作成することができるようになっています。

![](https://kazupon.github.com/images/20171225_sfc_functional_components.png)


# さらに繁栄するエコシステム
Vue.js の成長とともにエコシステムが形成し成長してきましたが、2017年においてはメジャーなライブラリやUIフレームワークはVue 2.0 対応がひと通り完了して安定化してきた1年と言えるでしょう。特に Nuxt.js は Vue.js のサーバサイドレンダリングの改善とともに精錬されて、現在 1.0 のリリース可能な状態までになってきている状況です。

今年2017年において、Vue.js 周りのエコシステムの拡大した出来事で一番大きいのは、[Storybook v3.2](https://medium.com/storybookjs/announcing-storybook-3-2-e00918a1764c) で Vue.js をサポートしたことでしょう。

![](https://cdn-images-1.medium.com/max/2000/1*fUZGDSIAVBJYKNaAd_yZaw.gif)

Storybook はコンポーネントといったUI開発環境を提供するツール的なものですが、React.js、Raact Native といった React 関連ののみしかサポートしていませんでした。同様なものとして、[vue-play](https://github.com/vue-play/vue-play)がありますが、作者の[egoist](https://github.com/egoist)氏が vue-play に対して活動がアクティブではおらず、Storybook と同等のものが利用できる状態ではありませんでした。

<script async class="speakerdeck-embed" data-slide="18" data-id="d5eaeb9b469e44a687345554db753ed4" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

そんな中、上記の Issue 投稿をきかっけに、Storybook で Vue.js をサポートするために Storybook のメンバーといっしょに自分も開発を進めてリリースできたことは、大変エキサイティングであったし、Vue.js ユーザーが Storybook を使って効率的なコンポーネント開発を可能になるのは、開発体験(DX: Development Experience)がよくなるため、Vue.js にとっても大変良いことです。

今回の対応は、Storybook も Vue.js にとってもどちらとも Win-Win になれて、双方のエコシステムを拡大できた出来事であったことに間違いないでしょう。


# さらに成長するコミュニティ

## Meetup
去年 2016 年、Veu.js の成長に伴いコミュニティもかなり成長しましたが、今年 2017 年は去年よりもさらにコミュニティが成長しています。

世界規模の Meetup イベントサービスの[Meetup](https://www.meetup.com)、この[クエリ](https://www.meetup.com/find/?allMeetups=false&keywords=vue.js&radius=Infinity&sort=recommended&eventFilter=all&_cookie-check=RYvaN12hmUVBu01Z)で検索するとかなりの数のコミュニティグループが見つかり、Meetup イベントが開催されています。

日本では、今年は自分が主催する Vue.js 日本ユーザーグループ主催による Meetup イベントを 4 回開催しました。

- [Vue.js Tokyo v-meetup="#3"](https://vuejs-meetup.connpass.com/event/48462/) (参加申し込み数: 251)
- [Vue.js Tokyo v-meetup #4](https://vuejs-meetup.connpass.com/event/58071/) (参加申し込み数: 294)
- [Vue.js Tokyo v-meetup #5](https://vuejs-meetup.connpass.com/event/65442/) (参加申し込み数: 243)
- [Vue.js Tokyo v-meetup #6](https://vuejs-meetup.connpass.com/event/69761/) (参加申し込み数: 270)

今年 2017 年に入ってから、常に参加申し込み(connpassの管理ダッシュボードで確認できる統計)が 200 オーバーしており、ここ最近開催された `Vue.js Tokyo v-meetup #6` では、申込み受付開始から 13 分で定員になってしまうほどの状況です。(このようにイベント参加倍率が高い状況になっており、今後、Vue.js 日本ユーザーグループスタッフ一同、一人でも多くの方が参加できるように努力していきたいです🙇)

connpassで、キーワード`Vue.js`を指定してイベント検索すると明らかに 2016 年と、2017 年とでは、検索にひっかかるイベント数今年 2017 年の方が圧倒的強さです。

- [2016 年の検索クエリ](https://connpass.com/search/?q=Vue.js&start_from=2016%2F01%2F01&start_to=2016%2F12%2F31)
- [2017 年の検索クエリ](https://connpass.com/search/?q=Vue.js&start_from=2017%2F01%2F01&start_to=2017%2F12%2F31)

## チャット
今年 2017 年の 6 月、Vue.js が公式で運営するチャットを、[gitter](https://gitter.im/vuejs/vue) から [discord (Vue Land)](https://vue-land.js.org) に運営を移行しました。discord は、以下のような slack ライクなチャットサービスとなっているため、チャンネルで話したいトピックをグループ化できるため、gitter よりかなりよいです。Discord に移行してから、さらにチャットによるコミュニケーションは活発になっています。

![](https://kazupon.github.com/images/20171225_vue_land.png)

日本においては、去年 2016 年開設した Vue.js 日本ユーザーグループが公式に運営する [Slack](https://vuejs-jp-slackin.herokuapp.com) がありますが、去年の同じ時期では登録者数が 212 人だったのが、今年 2017 年のこの記事執筆段階では 1000 人を超えた状況で、日本も slack を通してコミュニケーションが活発になっています。

<blockquote class="twitter-tweet" data-lang="en"><p lang="ja" dir="ltr">Vueの日本ユーザーグループのslack、1000に達した。🎉 <a href="https://t.co/bnK381ddqL">pic.twitter.com/bnK381ddqL</a></p>&mdash; 🐤kazuya kawaguchi🐤 (@kazu_pon) <a href="https://twitter.com/kazu_pon/status/941530916358205440?ref_src=twsrc%5Etfw">December 15, 2017</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


# 初の公式カンファレンス開催
今年2017年の Vue.js における最大の出来事としては、なんといっても、初の公式カンファレンス VueConf 2017 が開催されたことでしょう。

<iframe width="560" height="315" src="https://www.youtube.com/embed/TsgdiXGWlIY" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>

公式カンファレンスの[サイト](https://conf.vuejs.org)を見てもらえれば分かると思いますが、コアチームと各分野のスペシャリストが集結した豪華スピーカーによるカンファレンスです。

各スピーカーの発表は、YouTube で動画が公開されているので、興味ある方は、[こちら](https://www.youtube.com/channel/UC9dJjbYeXjirDYYVfUD3bSw/videos)の動画一覧から見てみると良いでしょう。

また、このカンファレンスに、コアチームの [ktsn](https://github.com/ktsn) さんが参加して[レポート記事](https://dev.oro.com/posts/2017/07/event/vueconf2017-report/)を書いているので、どんな感じだったのか雰囲気をつかむこともできると思います。


# Vue.js の今後
これまでに今年2017年 Vue.js 界隈における状況、出来事をまとめてきました。特に Vue.js のメジャーバージョンのリリースはありませんでしたが、4つのリリースを経ることで、Vue.js は Progressive に着実に進化してきました。

Vue.js は現在、[コアチーム、そしてコミュニティパートナー](https://jp.vuejs.org/v2/guide/team.html)の体制で Vue.js 本体や、Vue Router や Vuex などの公式で提供する関連ライブラリ開発や、ドキュメントのメンテナンス、翻訳、そして Vue.js を取り巻く Nuxt.js、Storybook のようなエコシステムと連携しあって活動しています。

## Vue.js プロジェクトロードマップ
そんな中、2017年9月26日に HashNode で [Vue.js コアチームによる AMA (Ask Me Anything: 何か質問ある?)](https://hashnode.com/ama/with-vuejs-team-cj7itlrki03ae62wuv2r2005s) を開催しました。その中で、Vue.js コミュニティユーザーから Vue.js の今後についていろいろと質問と回答のやり取りがあった後、将来に向けた[ロードマップ](https://github.com/vuejs/roadmap)が公開されました。

ロードマップの内容については、`Vue.js Tokyo v-meetup #6` で私の発表した下記のスライドで確認することができます。また[動画](https://crash.academy/class/193)も公開されているので、そちらでも確認できます。

<script async class="speakerdeck-embed" data-id="7d437d38c31b46318998d120b2d9c929" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>

このロードマップをベースに、Vue.js のプロジェクトとして Evan 氏を筆頭にコアチームの各メンバーによって、ドキュメントの改善、関連ライブラリなどの開発が進められている状況です。来年2018年も引き続き、コアチーム体制でロードマップに従ってコミュニティベースのオープンソースプロジェクトとして進めていくでしょう。

## 2018 年のカンファレンス
2018年、今年以上にカンファレンスが予定されています。現時点で以下が予定されています。

- [Vue.js Amsterdom](https://www.vuejs.amsterdam): 2018年2月16日
- [VueConf US](http://vueconf.us): 2018年3月26日〜2018年3月28日
- [Vue.js London](http://vuejs.london): 2018年4月以降予定
- VueConf EU: 2018年9月予定
- Vue.js Conference Japan (仮): 2018年7月末、8月初旬で調整中

現在調整中ですが、日本でも開催するために、Vue.js 日本ユーザーグループスタッフで今進めています。海外からも Evan 氏を筆頭に、コアチーム、Vue コミュニティパートナーの方を呼んで、公演してもらうよう調整中です。来年2018年早々、カンファレンス専用サイトを公開する予定ですので、楽しみにして頂ければと思います！


# おわりに
Vue.js #1 Advent Calendar 2017 の最終日、そして4つのアドベンドカレンダの取りまとめとして、Vue.js の統括的な内容を書きましたが、いかがでしたでしょうか？

2018年も引き続き、Vue.js コアチームのメンバとともに、

    We are on a mission to help more frontend devs enjoy building apps for the web

という、Vue.js のミッションに従って、Web フロントエンド開発者の開発体験をよくするためにオープンソースソフトウェアの活動に取り組んでいきますのでの、よろしくお願いします。

それでは、みなさんよいお年を! <img src="https://kazupon.github.com/images/20171225_vue_logo.png" width="20px" height="20px">
