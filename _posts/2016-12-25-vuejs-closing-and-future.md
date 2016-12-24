---
tags: vue.js vuejs vue
format: markdown
slug: 2016-vuejs-in-review
title: Vue.js 2016年まとめ & 今後
type: text
--

この記事は、[Vue.js Advent Calendar 2016](http://qiita.com/advent-calendar/2016/vue)の25日目最後の記事です。

フロントエンド界隈の技術、[ここ最近何も進歩していない](http://mizchi.hatenablog.com/entry/2016/12/14/191013)と言われてますが、Vue.js では今年2016年はいろいろとあり激動でした。

そんな Vue.js 界隈における出来事を Vue.js コアチームメンバ & Vue.js 日本ユーザーグループの orgnaizer の立場でまとめつつ、最後に Vue.js の今後について少し話して、Vue.js Advent Calendar の最後を締めくくりたいと思います。

# 2.0 リリース！
一番の大きな出来事といったら、やはり、Vue.js 2.0 のリリースでしょう！

<blockquote class="twitter-tweet" data-lang="ja"><p lang="en" dir="ltr">Behold! Vue 2.0 is officially out! <a href="https://t.co/OVgGo4epCO">https://t.co/OVgGo4epCO</a></p>&mdash; Vue.js (@vuejs) <a href="https://twitter.com/vuejs/status/781931137937571840">2016年9月30日</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

今年の4月末に[Vue.js公式ブログ](https://medium.com/the-vue-point/announcing-vue-js-2-0-8af1bde7ab9#.ktnf9a0zw)で「これから 2.0 を出すぜ!」的な発表をして当初は今年の6月上旬のリリースされる予定でしたが、少しVue.jsのユーザーには待たせてしまいましたが、今年の8月に[RCバージョンをアナウンス](https://medium.com/the-vue-point/the-state-of-vue-1655e10a340a#.6128omyax)し、今年10月1日に[無事リリース](https://medium.com/the-vue-point/vue-2-0-is-here-ef1f26acf4b8#.4ryrkyrpa)というリリースのロードを歩みました。

Vue 2.0 での技術的な一番の目玉は、Virtual DOM の採用です。これまでのバージョン1.x までは、生の DOM ベースによるレンダリングでしたが、2.0 では Virtual DOM を採用してレンダリング周りを刷新しました。これに伴う効能として、パフォーマンスの改善はもちろんなのですが、従来では難しかったサーバサイドレンダリングが出来るようになり、HTMLテンプレートによる宣言的なレンダリングだけでなく、HyperScript/JSXによる命令的なレンダリングも可能になってレンダリング手段が柔軟になり、そして React Native と同様にクロスプラットフォーム対応という風に、Vue.js として様々な可能性を広げられるようになりました。

2.0 リリース後、様々なバグ修正や機能改善など経て、この記事執筆時点では [2.1.7](https://github.com/vuejs/vue/releases/tag/v2.1.7) が最新バージョンとなっている状況です。

ちなみに、Vue.js はコードネームがアニメのものから付けられることで有名ですが、今年リリースされたもののコードネームは以下のとおりです。

- 2.0: Ghost in the Shell (攻殻機動隊)
- 2.1: Hunter X Hunter


# 爆発的な成長
下記のVue.js公式Tweetからも分かるように、2016年は急速に成長したとも言えるでしょう！

<blockquote class="twitter-tweet" data-lang="ja"><p lang="en" dir="ltr">…and we thought 2015 was an explosive year! <a href="https://t.co/Dn1UsDQRgw">pic.twitter.com/Dn1UsDQRgw</a></p>&mdash; Vue.js (@vuejs) <a href="https://twitter.com/vuejs/status/810671430631391232">2016年12月19日</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

2015年4月に PHP Web アプリケーションフレームワーク "[Laravel](https://laravel.com)" に Vue.js が標準搭載を決定するのを機会に Laravel コミュニティの間で普及して成長していきましたが、今年 2016年はそれ以上に急速に成長しました。

GitHub の star も今年1月初めには 10K ちょっとだったのが、この記事執筆時点では、37K 超えという状況になっています。

![](https://kazupon.github.com/images/20161225_github_star.png)

他に Vue.js公式サイトのページビュー数、NPM ダウンロード数などの数値的なものは、今年の8月のものでちょっと古いですが、Vue.js 公式ブログの[こちら](https://medium.com/the-vue-point/the-state-of-vue-1655e10a340a#21bf)にあります。(最新の数値的なものは近々 Evan 氏がレビュー的なブログで公開すると思います。)

今年これだけ成長した要因は、これまでに自分自身、Twitter、GitHub などの SNS、Web メディア、そして Vue.js コアチームメンバー内のやり取りを見てきた感じからすると、肌感覚でふわっとした感じになりますが、以下が要因なのではないかと考えています。

## 1. Evan 氏出身の中国の JavaScript フロントエンドユーザーの間ではほとんど利用していること
10億オーバーの人口を持つ中国。その数のうちの0.1%がフロントエンドエンジニアがいたとしても、100万強のオーダーなので、GitHub の start の数、NPM のダウンロード数、ページビュー数に与える影響は半端ないと考えています。ちなみに、Evan 氏が今年の中国での今年の[JSConf](http://2016.jsconf.cn/#/?_k=p3vp5m)の時にどれだけ Vue.js について利用状況について公演時に聴講者に聞いたところ、イベント参加者ほぼ全員利用していたとのことです。

## 2. Evan 氏が今年かなりの数の各国の JavaScript コミュニティのイベントに登壇したこと
Evan 氏は以下で列挙したスライドの数だけ、今年はかなりの数の各国の JavaScript コミュニティにイベントに登壇しているので、PR になったんではないかと思います。

- スライド
    - [Laracon US: Vue.js Make Frontend Development Great Again!](https://docs.google.com/presentation/d/16MpK3I2LZz47QdLg3uMNkCC3PqmM0znXF3-FdCEpics/edit#slide=id.p)
    - [Laracon EU: Modern Frontend Development with Vue.js](https://docs.google.com/presentation/d/1zQ3Frm3DxSw_qY-KEuykkIUREO-ueFbOyMd1Kd8nqKE/edit#slide=id.p)
    - [Midwest JS: Vue.js: The Progressive Framework](https://docs.google.com/presentation/d/1WnYsxRMiNEArT3xz7xXHdKeH1C-jT92VxmptghJb5Es/edit#slide=id.p)
    - [NingJS: Vue.js: the Past and the Future](https://docs.google.com/presentation/d/12Yy2SjYOow0x_FaCTHqv7wejs-J5z2oDvrpCScpFzAo/mobilepresent?slide=id.p)
    - [Nordic.JS: Demystifying Frontend Framework Performance](https://docs.google.com/presentation/d/1Ju5NryLLI-2aXm_XwsdF5rU0QpOpeyVW9F8JeeSuj-k/mobilepresent?slide=id.p)
    - [dotJS: Reactivity in Frontend JavaScript Frameworks](https://docs.google.com/presentation/d/1_BlJxudppfKmAtfbNIcqNwzrC5vLrR_h1e09apcpdNY/edit)
- 発表動画
    - [Laracon EU: Modern Frontend with Vue.js](https://youtu.be/D_z-RAweP1k)
    - [Midwest JS: Vue.js: the Progressive Framework](https://youtu.be/pBBSp_iIiVM)
    - [NingJS: Vue.js: the Past and the Future](https://youtu.be/EiTORdpGqns)
    - [Nordic.JS: Demystifying Frontend Framework Performance](https://youtu.be/Ag-1wmHWwS4)
    - [dotJS: Reactivity in Frontend JavaScript Frameworks](https://youtu.be/r4pNEdIt_l4)

## 3. Web メディアで計画的に PR をしたこと
Twitter では Vue.js 関連のキーワードをウオッチしてリツイート/コメントしたりして日々マメに対応しているのと、メジャーリリースにおいてときは、ブログ記事はもちろん、必ず HackerNews や Reddit に投稿したりしてかなり意識的に PR していたんではないかと思います。


# Evan 氏の Vue.js フルタイム化
今年は、Evan 氏が Vue.js にフルタイムで開発できるようになりました!

Evan 氏は [Meteor](https://www.meteor.com) で働いていましたが、2015 年の Vue.js の成長に伴い Meteor を[辞めて](https://www.linkedin.com/in/evanyoua)自分の会社を設立しました。その後、Vue.js フルタイム開発を行うために今年の 3 月に [Patreon](https://www.patreon.com/evanyou)で $6,000/manth を目標に支援を募集開始しました。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="en" dir="ltr">In particular: I have started a Patreon campaign seeking funding to focus on Vue fulltime. <a href="https://t.co/pukJfFk5eX">https://t.co/pukJfFk5eX</a></p>&mdash; Vue.js (@vuejs) <a href="https://twitter.com/vuejs/status/709512402589650944">2016年3月14日</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

場集開始後、今年の 6 月には、3 ヶ月足らずで 目標の $6,000/month にあっという間に達成して、現在では $9,000/month 以上 Patreon で支援を受けています。また、最近 Alibaba の[Weex](https://alibaba.github.io/weex/) プロジェクトの技術顧問になり、Weex プロジェクトの開発にもコミットメントしている状況です。


# コアチームによる Vue.js OSS 開発
今年は、コアチームメンバー体制による Vue.js OSS 開発が正式開始しました!

従来 vue.js の開発は、Vue.js orgnaization メンバー 6 名で Vue.js プロジェクトを活動してきたのですが、基本は Evan 氏を中心に、Vue.js 本体、関連プラグイン、ドキュメント、コミュニティサポートをほとんど一人でやっていました。ですが、2015 年に先に説明した Laravel の採用に伴う急速な成長に伴い、助けが必要になってきました。そこで、今年の 3 月の Patreon による支援の開始とともに、Evan 氏がコアチーム用の Slack を立ち上げる形で正式に Vue.js コアチームをキックオフしました。

コアチームスタート時は、17名の体制でスタートしましたが、その後もコアチームメンバーはどんどん増えていって、現在は30名弱の体制で活動しています。コアチームメンバーは、アメリカ、ドイツ、フランス、イギリス、ロシア、インド、ベトナム、中国、日本などというようにグローバルな多国籍メンバー構成になっています。ちなみに現時点の日本人のコアチームメンバーは、

- @kazupon (私)
- [@tejitak](https://github.com/tejitak) さん
- [@ktsn](https://github.com/ktsn) さん
- [@kaorun343](https://github.com/kaorun343) さん
    
の4名が在籍しています。


## コアチームメンバーの役割
チームメンバーの役割としては以前イベントで発表したこちらの[資料](https://speakerdeck.com/kazupon/vue-dot-js-new-team)に記載していますが、主に

- GitHub Issues のトリアージュ
  - バグレポートのチェック (本当にバグなのか?ただ単の質問のなのか?)
  - 新機能要望リクエストのチェック (ユースケースは何のか?メリットはあるのか?)
  - 放置された Issues のクリーニング (質問待ちしていてもレスポンスが5日以内に来ない場合)
- Pull Request のレビュー
- バグ修正または新機能の実装
- 他のコアチームメンバのサポート
- [フォーラム](https://forum.vuejs.org)またはGitterのコミュニティサポート

のようなことをして Vue.js を OSS として運用・開発しています。

## コアチームメンバーの開発体制
開発体制としては、特に明文化したものはないのですが、大半は Evan 氏で仕様策定、実装、バグ修正はしているのですが、コアチームメンバが自主的にバグ修正、機能改善はもちろん、ツールなどを作成などをすることで、Evan 氏がこれまで全てやっていたことが徐々に負荷分散される形の開発体制になってきています。

今年リリースした Vue 2.0 のような大きい開発のケースを上げると、仕様策定・実装は Evan 氏が大方やって pre-alpha な状態まで開発し、API の互換性などの仕様が一人で決められない場合は、コアチームメンバ内部で議論して、その後 GitHub の issue として公開して、ユーザーからフィードバックを得るようなスタイルで開発してきています。pre-alpha リリース後は、引き続き足りない機能などの実装は Evan 氏が実装し、単体テスト、公式サイトのドキュメント整備、マイグレーションツール、そして TypeScript 対応はコアチームメンバーが自主的に取り組んで開発していったという状況です。


# エコシステムの成長
Vue.js 周りのエコシステムも引き続き成長し続けています!

[vue-awesome](https://github.com/vuejs/awesome-vue)が公開されて以降、これに Vue.js 関連のフレームワーク、ライブラリ、ツールなどが登録されてエコシステムが形成されて来ましたが、2.0 のリリース以降も引き続き成長しています。バージョン 2.0 リリース以降、現在は以下のようなものが注目されています。

- [Weex](https://alibaba.github.io/weex/): Vue.js のシンタックスで Web だけでなく iOS/Android といった Native 向けへのアプリを開発できるクラスプラットフォーム向けのフレームワーク
- [Nuxt.js](https://nuxtjs.org): [Next.js](https://zeit.co/blog/next)の Vue.js 版のサーバサイドレンダリングに向けの Web アプリケーションフレームワーク
- [vuelidate](https://monterail.github.io/vuelidate/): model ベースなシンプルなバリデーションライブラリ
- [eva.js](https://github.com/egoist/eva.js): [choo](https://github.com/yoshuawuyts/choo) と [elm architecture](https://guide.elm-lang.org/architecture/) にインスパイアされた Web アプリケーションフレームワーク
- [Element](http://element.eleme.io/): Web 向けの UI ツールキット
- [vuetify](https://vuetifyjs.com):  Material Design ベースのコンポーネントフレームワーク
- [Quasar Framework](http://quasar-framework.org): Vue.js のコードでNativeのようなモバイルアプリとレスポンシブなWebサイトを構築できるフレームワーク


# 翻訳活動の活発化
Vue.js ドキュメント関連の翻訳も世界各国を通して活発化しています!

Vue.js 公式ドキュメントは、バージョン 1.x のときは翻訳され公式サイトにリンクされていたのは、日本語、中国語、イタリア語しかありませんでした。バージョン 2.0 では、日本語と中国語の他に、ロシア語、韓国語も翻訳されており公式サイトから参照できるようになっています。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="en" dir="ltr">In case you haven’t noticed: Vue 2 docs are now also available in Chinese, Japanese, Russian and Korean, all contributed by the community! <a href="https://t.co/DAXVMOpg0b">pic.twitter.com/DAXVMOpg0b</a></p>&mdash; Vue.js (@vuejs) <a href="https://twitter.com/vuejs/status/809193954298232832">2016年12月15日</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Vue.js 公式ドキュメントの翻訳は、現状他にも[フランス語](https://github.com/vuejs/vuejs.org/issues/271)といった翻訳も活発です。

Vue.js 公式ドキュメント以外にも、[vue-router](https://vue-router.vuejs.org)、[vuex](https://vuex.vuejs.org)、[vue-loader](https://vue-loader.vuejs.org)といった公式プラグイン・ツールのドキュメントも活発に翻訳されて続けています。


# コミュニティの成長
Vue.js の爆発的な成長に伴い、コミュニティも成長しています！

## Meetup イベント
Vue.js の成長とともに、ユーザーコミュニティ主導の Meetup イベントが[パリ](https://www.meetup.com/Vuejs-Paris/)、[ロンドン](https://www.meetup.com/London-Vue-js-Meetup/)といったように世界各国で活発に開催されています。以下は最近開催された Evan 氏も直接参加したパリの Meetup の様子です。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="en" dir="ltr">Vue.js Paris meetup right now! <a href="https://t.co/VxM23gbuVy">pic.twitter.com/VxM23gbuVy</a></p>&mdash; Vue.js (@vuejs) <a href="https://twitter.com/vuejs/status/805117056253390848">2016年12月3日</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

日本でも自分が orgnaize する Vue.js 日本ユーザーグループ主催による Meetup イベントを 2 回開催しました。

- [Vue.js Tokyo v-meetup="#1"](https://vuejs-meetup.connpass.com/event/31139/)
- [Vue.js Tokyo v-meetup="#2" 祝 2.0 リリース記念](https://vuejs-meetup.connpass.com/event/41955/)

Meetup イベントの 1 回目のイベントである v-meetup="1" では、Evan 氏に Skype で参加してもらい、Q & A 形式で参加者といっしょに非常にエキサイティングな時間を過ごしました。以下のその時の様子です。(写真ボヤケてすいません。。。)

<blockquote class="twitter-tweet" data-lang="ja"><p lang="en" dir="ltr"><a href="https://twitter.com/hashtag/vuejs?src=hash">#vuejs</a> <a href="https://twitter.com/hashtag/vmeetjp1?src=hash">#vmeetjp1</a> Q &amp; A session With Evan You <a href="https://t.co/DBlaFswOgF">pic.twitter.com/DBlaFswOgF</a></p>&mdash; 🐤kazuya kawaguchi🐤 (@kazu_pon) <a href="https://twitter.com/kazu_pon/status/737621351893078016">2016年5月31日</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

また、会社主催によるVue.js Meetup イベントも開催され、そこでも Evan 氏が Skype で参加してくれて、Q & A セッションをやって盛り上がりました。

- [ABEJA Meetup「Vue.js: Revolutionary Front-end #1 With Evan You!」レポート](https://www.wantedly.com/companies/abeja/post_articles/34262)

## 日本ユーザー向けの Slack の開設
日本 Vue.js ユーザー向けに [Slack](https://vuejs-jp-slackin.herokuapp.com) を5月に開設しました。この Slack では、Vue.js 関連の情報配信されていたり、Vue.js ユーザー同士で分からないことを Q & A などして、活発にコミュニケーション出来る場になっています。Slack の登録者数は、この記事執筆時点で 212 人で今もなお登録者数が増えて続けており、コミュニケーションが活発になっています。


# 公式ライブラリの整理
Vue.js はこれまでに以下のライブラリを公式プラグインとしてサポートしてきましたが、バージョン 2.0 以降では公式にはサポートしなくなりました。

- [vue-resource](https://github.com/pagekit/vue-resource) 
- [vue-validator](https://github.com/kazupon/vue-validator)

vue-resource については以下の Vue.js 公式ブログの[記事](https://medium.com/the-vue-point/retiring-vue-resource-871a82880af4#.8r67jlbu6)でアナウンスしており、今後は [pagekit](https://pagekit.com) のプロジェクトでメンテナンスされます。vue-validator について公式にはアナウンスはしていませんが、こちらは、これまで自分が開発 & メンテナンスしていましたが、vue-resource と同じ理由でこちらから願いでてリタイアしました。引き続き vue-resource と同様に自分の個人プロジェクトとして対応していきます。


# Vue.js の今後
今年2016年 Vue.js 界隈における出来事をまとめてきましたがいかがでした? Vue.js はフロントエンドの技術において革命的なものをリリースして「これ凄い！」というものはありませんでしたが、フロントエンドユーザーに受け入れられるものに進化していった1年だったということが分かります。

Vue.js の今後ですが、現在確定しているものとしては以下があります。

## VueConf 開催決定!
来年2017年夏に、ポーランドで初の Vue.js 公式カンファレンス「VueConf」を開催することになりました。

<blockquote class="twitter-tweet" data-lang="ja"><p lang="en" dir="ltr">It is happening! First <a href="https://twitter.com/vuejs">@vuejs</a> conference is now officially ON! Will you join us? <a href="https://t.co/MTnxaSdmzH">https://t.co/MTnxaSdmzH</a> <a href="https://twitter.com/hashtag/vuejs?src=hash">#vuejs</a> <a href="https://t.co/kUA1oeY3Ji">pic.twitter.com/kUA1oeY3Ji</a></p>&mdash; VueConf (@VueConf) <a href="https://twitter.com/VueConf/status/811626987085295617">2016年12月21日</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

ついここ最近[ランディングページ](https://conf.vuejs.org)をオープンし、CFP も開始しています。スケジュールや内容についての詳細は今後明らかになっていくでしょう。

## awesome-vue に変わる新しい Vue.js エコシステムのキューレションサイト
現在コアチームメンバー主導で新しい Vue.js のエコシステムのキューレションサイトのオープンを予定しています。

awesome-vue は Vue 0.12 の頃に公開されて今日まで運用してきましたが、情報が古いものや、登録されたライブラリ、フレームワーク、ツールといったものがメンテナンスされずVueの最新のバージョンに対応していなかったりと決して品質が良い状態とはいえません。また長年の運用により登録リストが膨大なため探しにくく、どれが Vue.js ユーザーにとって有用なのか評価される仕組みもありません。

こうした経緯から、現在 awesome-vue に変わる新しいエコシステムのキューレションサイトを作成しています。プロトタイプレベルのものは大方できているので、そんなに時間がかからずにオープンされるでしょう。

## Vue.js 本体と周辺ライブラリについて
一番気になると思われる Vue.js の今後ですが、正直に言うとコアチームメンバーである自分も、Evan 氏が特に今のところ今後について明言されているものはないので、確定したロードマップは分かりません。2.0 の時のように突然ゴニョゴニョと作りだして、何かリリースするかもしれません。

Vue.js の GitHub レポジトリには、[GitHub projects](https://github.com/vuejs/vue/projects/3) で共有されているので、このロードマップと Vue.js orgnaization にある PoC レベルのレポジトリから想定すると以下になるでしょう。

- Vue.js core
    - `keep-alive` コンポーネント周りの改善
    - サーバサイドレンダリングの改善 (code spliting / デバッギング周り)
- CLI / ビルドツール (vue-cli)
    - コンポーネントテストユーティリティ
    - 配布可能なコンポーネントのテンプレートとベストプラクティス
    - Electron ベースの playground (React Storybook 的なもの?)
    - Webpack 2.0 ベースのテンプレート
- 開発ツール (vue-devtools?)
    - 編集可能な state インスペクタ
    - コンポーネントレンダリングパフォーマンスのプロファイリングツール
    - Vuex store のロックモード
    - Vuex ユーザーセッションレベル?のレコード&再生ツール
    - [RxMarble](http://rxmarbles.com)スタイルのような視覚化されたアクション/ミューテションログ
- vue-router
    - route 定義方法の改善
- vuex
    - [vuex-observable](https://github.com/vuejs/vuex-observable)


# おわりに
Vue.js Advent Calendar 2016 の最終日として、Vue.js の統括的な内容を書きましたが、いかがでしたでしょうか？

コアチームメンバーとして来年度の Vue.js も頑張って引き続きフロントエンドフレンドリーなフレームワークとして進化させていきますので、ぜひフィードバックとかくれたら助かります。

Vue.js 日本ユーザー向けの MeetUp も2月か3月に計画していますので、ぜひ楽しみにしていてください。会場提供したいという方がいましたら私まで声かけて頂けるとありがたいです。ゆくゆくは、日本版の VueConf Japan みたいなものも開催して、Evan 氏呼べたらいいですね！

Happy Holidays !! 🎅 
