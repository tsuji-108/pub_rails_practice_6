# pub_rails_practice_6

## TODO

Rails に検索機能を実装してみる  
GET: /todos に対して、検索条件を指定して取得できるようにする

## コマンド

| コマンド         | 内容                 |
| ---------------- | -------------------- |
| rails db:reset   | DB をリセット        |
| rails db:migrate | マイグレーション実行 |
| rails db:seed    | seed 実行            |     |

## やったこと

- `rails g scaffold todo` で Todo モデルを作成
  - title: string, content:text, is_completed: boolean で生成
- db/seeds.rb にテストデータを用意
- TodosController `index` に検索機能を更新
  - 任意のクエリパラメータ（title, content, is_completed）を元に Todo を検索できるようにした
    - 対応キー: `name`, `content` は部分一致、`is_completed` は完全一致
