class Todo < ApplicationRecord
  # searchkick 用のメソッドをモデルに追加する
  searchkick

  # search_data メソッドの戻り値が実際に OpenSearch のインデックスに追加される情報（ドキュメント）になる
  def search_data
    {
      name: name,
      content: content,
      is_completed: is_completed,
      created_at: created_at,
      updated_at: updated_at
    }
  end
end
