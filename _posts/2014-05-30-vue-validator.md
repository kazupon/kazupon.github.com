---
tags: vue.js
format: markdown
slug: vue-validator
title: Vue.js向けのvalidatorを作ってみた
type: text
--
[Vue.js](http://vuejs.org) には [vue-validator](https://github.com/vuejs/vue-validator) という plugin で validation 機能を、界王拳まではいかずとも Vue の戦闘能力を増幅させるものがあるんだけど、開発が全然進まないので、[fork](https://github.com/kazupon/vue-validator) して自分で勝手に作ってみた。


# インストール
vue-validator は [component](https://github.com/component/component) を使えば、簡単にインストールできる。

    $ component install kazupon/vue-validator

[bower](http://bower.io/) という七面鳥みたいな変な鳥のキャラで有名なパッケージ管理ツールでも対応する予定。


# 使い方
説明するより、サンプルコードを見た方がどんなもんか理解するのが速いと思うので、以下のコードを載せておく。

## html

    <form id="blog-form" v-validate>
        <input type="text" v-model="comment | length min:16 max:128">
        <div>
            <span v-show="$validation.comment.length.max">too long your comment.</span>
            <span v-show="$validation.comment.length.min">too short your comment.</span>
        </div>
    </form>

## js
    // import(s)
    var Vue = require('vue');
    var validator = require('vue-validator');

    // install validator
    Vue.use(validator);

    new Vue({
        el: '#blog-form',
        data: {
            comment: ''
        }
    });

上記は、ブログなどの Form でコメントを入力する際の、よくあるコメントの validation のサンプル。

`v-validate` という directive を validation の対象となる form や div などのコンテナ的なタグに指定する。指定すると実行時に

- `$validation` が ViewModel インスタンスに生える
- `$valid` が ViewModel インスタンスに生える
- `v-model` で validation filters が使えるようになる
- `v-model` の validation filter によって validation の結果が `$validation` の保持されるようになる

というように Vue に validation 機能を拡張する感じになる。


# $validation
`$validation` は、各 `v-model` ごとの validation 結果を以下ようなフォーマットで保持する。

    $validation.model.filter[.filter_param]

`required` validation filter の場合は、以下のようになる。

    <form id="user-form" v-validate>
        Password: <input type="password" v-model="password | required"><br />
        <div>
            <span v-show="$validation.password.required">required your password.</span>
        </div>
    </form>


# $valid
`$valid` は、`v-validate` の全 validation の結果を `true | false` で保持する。ユースケースとしては、以下のような Form で submit ボタンを `v-if` で動的に表示するような、全ての validation がパスしていないと駄目なケースで利用するとよい。

    <form id="user-form" v-validate>
        ID: <input type="text" v-model="id | required | length min:3 max:16"><br />
        Password: <input type="password" v-model="password | required | length min:8 max:16"><br />
        <input type="submit" value="send" v-if="$valid">
        <div>
            <span v-show="$validation.id.required">required your ID.</span>
            <span v-show="$validation.id.length.min">too short your ID.</span>
            <span v-show="$validation.id.length.max">too long your ID.</span>
            <span v-show="$validation.password.required">required your password.</span>
            <span v-show="$validation.password.length.min">too short your password.</span>
            <span v-show="$validation.password.length.max">too long your password.</span>
        </div>
    </form>

# validation filters

vue-validator で利用できる validation filter は以下に示す5つ。

1. required
2. pattern
3. length
4. numeric
5. validator

## 1. required
`required` は値が入力されているかどうか validate する validation filter。

    <form id="user-form" v-validate>
        Password: <input type="password" v-model="password | required"><br />
        <div>
            <span v-show="$validation.password.required">required your password.</span>
        </div>
    </form>

## 2. pattern
`pattern` は入力された値がパラメータとして指定した正規表現のフォーマットどおりかどうか validate する validation filter。

    <form id="user-form" v-validate>
        Zip: <input type="text" v-model="zip | pattern /^[0-9]{3}-[0-9]{4}$/"><br />
        <div>
            <span v-show="$validation.zip.pattern">Invalid format of your zip code.</span>
        </div>
    </form>

## 3. length
`length` は入力された文字列の長さを validate する validation filter。`length` validate filter には以下のようなパラメータ

- `min`: 文字列の最小の長さ
- `max`: 文字列の最大の長さ

を指定することができる。

    <form id="blog-form" v-validate>
        <input type="text" v-model="comment | length min:16 max:128">
        <div>
            <span v-show="$validation.comment.max">too long your comment.</span>
            <span v-show="$validation.comment.min">too short your comment.</span>
        </div>
    </form>

## 4. numeric
`length` は入力された文字列が数値かどうか validate する validation filter。`numeric` validate filter には以下のパラメータを指定できる。

- `min`: 入力した値の最小
- `max`: 入力した値の最大

入力した値が、`numeric` ではない場合は、`value` が true になる。

    <form id="config-form" v-validate>
        <input type="text" v-model="threshold | numeric min:0 max:100">
        <div>
            <span v-show="$validation.threshold.numeric.min">too small threshold.</span>
            <span v-show="$validation.threshold.numeric.min">too big threshold.</span>
            <span v-show="$validation.threshold.numeric.value">Invalid threshold value.</span>
        </div>
    </form>

## 5. validator
`validator` はパラメータに指定したカスタムな validation 関数を実行して validate する、validate filter。特殊な validation が必要な場合に利用すると便利。

### html

    <form id="blog-form" v-validate>
        <input type="text" v-model="comment | validator validateCustom">
        <div>
            <span v-show="$validation.comment.validator.validateCustom">invalid custom</span>
        </div>
    </form>

### js
    new Vue({
        el: '#blog-form',
        data: {
            comment: ''
        },
        methods: {
            // Specify custom validate function
            validateCustom: function (val) {
                // write custom validation here as follows
                this.$validation['comment.validator.validateCustom'] = !(0 < val.length & val.length < 3)

                return val;
            }
        }
    })


# TODO
今後のTODOとしては以下のとおり。

- bower のサポート
- `v-model` 毎の `$valid`、`$dirty` 
- validation filter name の変更オプション
- `$validation` プロパティ名の変更オプション


# おわりに
vue-validator ですが、やっつけでエイ、ヤッ!っていう感じで実装した部分もあるので、バグがあるかもしれません。ひと通り、validation の基本的なものを実装したので、[fork 元のオリジナル](https://github.com/vuejs/vue-validator)の方に PullRequest 送って、見てもらっているところです。

興味がある人は、ぜひ使ってみて、フィードバック送ってもらえればと。:)


# 宣伝
vue-validator は一部、業務の時間を使ってるので、ちょいと会社の宣伝。

弊社CUUSOO SYSTEM ではいっしょに [cuusoo.com](https://cuusoo.com) のUI/UXの改善をお手伝いしてくれるデザイナーさんを募集しております。フルタイムな社員でなくても、フリーの方でも歓迎です。

興味がある方は、かずぽんまで連絡をば。お待ちしております。
