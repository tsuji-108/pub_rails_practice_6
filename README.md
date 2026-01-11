# pub_rails_practice_6

## 概要

Rails に検索機能を実装してみる。  
GET: /todos に対して、検索条件を指定して取得できるようにする。
試験的に [searchkick](https://rubygems.org/gems/searchkick) x [OpenSearch](https://opensearch.org/) も使ってみた。

## クイックスタート

1. brew 経由で elasticsearch 追加する
   - brew tap elastic/tap を実行する
   - brew install elastic/tap/elasticsearch-full を実行する
2. bundle install を実行する
3. rails db:migrate を実行する
4. rails db:migrate を実行する
5. rails db:seed を実行する
6. opensearch を起動する
   - brew services start opensearch
5. rails s を実行する
   - もろもろ正しく実装できているなら、http://127.0.0.1:3000/ にて todo 一覧が確認できる
7. （開発が終了したなら…）opensearch を終了する
   - brew services stop opensearch

## コマンド

### 事前準備

brew 経由で elasticsearch を追加

| コマンド                                    | 内容 |
| ------------------------------------------- | ---- |
| brew tap elastic/tap                        |      |
| brew install elastic/tap/elasticsearch-full |      |

### opensearch

| コマンド                       | 内容              |
| ------------------------------ | ----------------- |
| brew services start opensearch | OpenSearch の起動 |
| brew services stop opensearch  | OpenSearch の終了 |

### rails

| コマンド         | 内容                 |
| ---------------- | -------------------- |
| rails db:reset   | DB をリセット        |
| rails db:migrate | マイグレーション実行 |
| rails db:seed    | seed 実行            |

## やったこと

- `rails g scaffold todo` で Todo モデルを作成
  - title: string, content:text, is_completed: boolean で生成
- db/seeds.rb にテストデータを用意
- TodosController `index` に検索機能を更新
  - 任意のクエリパラメータ（title, content, is_completed）を元に Todo を検索できるようにした
    - クエリパラメータとの対応: `name`, `content` は like 部分一致。`is_completed` は完全一致。
    - 該当するクエリパラメータが存在しない場合はフィルターをかけない。
- [searchkick](https://rubygems.org/gems/searchkick) なるモノも入れてみた。
  - OpenSearch (Elasticsearch から派生したオープンソースの検索・分析エンジン。) と連携している。
  - 実装した内容は、ほぼ AI に書いてもらっている。後ほど調べてみる。

## リンク集

- OpenSearch
  - [OpenSearch](https://opensearch.org/)
  - [OpenSearch とは何ですか? | AWS](https://aws.amazon.com/jp/what-is/opensearch/)
- searchkick
  - [searchkick](https://rubygems.org/gems/searchkick)
  - [searchkick | Github](https://github.com/ankane/searchkick)
