class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show update destroy ]

  # GET /todos
  # OpenSearch による検索
  def index
    # Searchkick のクライアント種別を OpenSearch に設定
    Searchkick.client_type = :opensearch

    # インデックスが未作成なら作成（初回起動対策）
    unless Todo.searchkick_index.exists?
      Todo.reindex
    end

    # クエリパラメータ
    name = params[:name].present? ? params[:name] : nil
    content = params[:content].present? ? params[:content] : nil
    is_completed = params[:is_completed] == "true" ? true : params[:is_completed] == "false" ? false : nil

    # Searchkick による検索条件の組み立て
    query_text = [ name, content ].compact.join(" ")
    where = {}
    where[:is_completed] = is_completed unless is_completed.nil?

    begin
      result = Todo.search(query_text.presence || "*",
                           where: where,
                           operator: "and",
                           misspellings: false,
                           limit: 100)
    rescue Searchkick::MissingIndexError, OpenSearch::Transport::Transport::Errors::NotFound
      # 初回アクセスなどでインデックスが未作成の場合は作成して再試行
      Todo.reindex
      result = Todo.search(query_text.presence || "*",
                           where: where,
                           operator: "and",
                           misspellings: false,
                           limit: 100)
    end

    @todos = result.to_a

    render json: @todos
  end

  # GET /todos
  # 通常の Where 句による検索
  # def index
  #   # クエリパラメータ
  #   name = params[:name].present? ? params[:name] : nil
  #   content = params[:content].present? ? params[:content] : nil
  #   is_completed = params[:is_completed] == "true" ? true : params[:is_completed] == "false" ? false : nil

  #   puts name, content, is_completed

  #   # 検索
  #   @todos = Todo.all
  #   if name
  #     @todos = @todos.where("name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(name)}%")
  #   end
  #   if content
  #     @todos = @todos.where("content LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(content)}%")
  #   end
  #   @todos = @todos.where(is_completed: is_completed) unless is_completed.nil?

  #   render json: @todos
  # end

  # GET /todos/1
  def show
    render json: @todo
  end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /todos/1
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_content
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.expect(todo: [ :name, :content, :is_completed ])
    end
end
