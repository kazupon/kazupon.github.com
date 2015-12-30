---
tags: vue.js
format: markdown
slug: vue-validator-v0.11
title: vue-validatorをv0.11のVue.jsに対応した
type: text
--
この記事は [Vue.js Advent Calendar 2014](http://qiita.com/advent-calendar/2014/vue) の13日目の記事です！

以前[本家](https://github.com/vuejs/vue-validator)から fork した [vue-validator](https://github.com/kazupon/vue-validator) を実装したんですが、v0.11 系では全くとも動作しないため、v0.11 系でも動作するよう対応したので、軽く紹介したいと思います。


# Vue.jsの詳細対応バージョン
Vue.js の v0.11.2 以降が必要。v0.11.2 より前は、v0.11.2 で新たに公開になった API を利用しているため、動作しないので注意。


# インストール
以前のバージョンでは、`component` と `bower` しかサポートしていませんでしたが、今回はこれらを含む以下をサポート。

- browserify (npm)
- bower
- component
- duo
- webpack


# 使い方
以前のバージョンと同じく、`Vue.use` でプラグインをセットする形で利用可能になる。


    var Vue = require('vue')
    var validator = require('vue-validator')

    Vue.use(validator)


上記により、`v-validate` という directive が有効になり、この directive を使って以下のように利用することでバリデーションしていくことになる。

    <form id="blog-form">
      <input type="text" v-model="comment" v-validate="minLength: 16, maxLength: 128">
      <div>
        <span v-if="validation.comment.minLength">too long your comment.</span>
        <span v-if="validation.comment.maxLength">too short your comment.</span>
      </div>
      <input type="submit" value="send" v-if="valid">
    </form>

注意としては、`v-validate` は `v-model` と同じ element でないと動作しない。必ず、`v-model` といっしょに使う必要がある。

ちなみに以前バージョンでは、`v-validate` という directive はあったが基本何もせず、フィルタを駆使して Hack っぽいやり方で対応していた。


# バリデーション結果
以前のバージョンでは、バリデーションの結果は `data` で管理していたのではなく、Viewmodel インスタンスに `$validation`、$valida、など生やしたりして対応していた。このバージョン以降では、`data`にバリデーション結果を反映するようにしている。以下をサポートしている。

- validation
- valid
- invalid
- dirty

# ビルドインバリデータ 
以下をバリデータをサポートしている。

1. required
2. pattern
3. minLength
4. maxLength
5. min
6. max

# ユーザーカスタムバリデータ
以前のバージョンと同様サポートしている。v0.11では Viewmodel のインスタンス生成時、もしくは `Vue.extend` など、以下のようなオプションにする形で対応可能。

    var MyComponent = Vue.extend({
      data: function () {
        return {
          name: '',
          address: ''
        }
      },
      validator: {
        validates: {
          email: function (val) {
            return /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(val)
          }
        }
      }
    })

    new MyComponent().$mount('#user-form')


# オプション

## 名前空間
今回対応した `vue-validator では、バリデーション結果は、内部で inherit オプションをしているため、`data` の名前空間と conflict する可能性がある。

以下のように、validator オプションで、conflict しないようにすることが可能。

    var MyComponent = Vue.extend({
      //...
      validator: {
        namespace: {
          validation: 'myValidation', 
          valid: 'myValid', 
          invalid: 'myInvalid', 
          dirty: 'myDirty'
        }
      }
      //...
    })


# レポジトリ
- [https://github.com/kazupon/vue-validator](https://github.com/kazupon/vue-validator)

# 対応し終えて感想
最初は、`v-component` を使った完全にコンポーネントベースで作っていたんだけど、[v0.11.1](https://github.com/yyx990803/vue/releases/tag/0.11.1) でこの `v-component` の動作が変わってしまって、はじめから作り直しになってつらかった。。。だけど、v0.11.2 でいろいろと内部の API が公開されたおかげで、楽になったので結果的にはよかったかと。

こんな、そんなで Vue.js のバージョンアップで振り回されて対応が遅れに遅れた `vue-validator` 、使ってかわいがって頂けると大変ありがたいです。:)

