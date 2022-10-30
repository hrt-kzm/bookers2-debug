class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    # 検索メニューで指定された対象(model)を変数に代入
    @model = params[:model]
    # 検索フォームに入力された内容を変数に代入
    @content = params[:content]
    # 検索メニューで指定された検索手法を変数に代入
    @method = params[:method]
    # 検索対象が'user'だった場合
    if @model == 'user'
      # 検索条件に当てはまるデータを変数に代入する
      @records = User.search_for(@content, @method)
    # それ以外('book')の場合
    else
      # 検索条件に当てはまるデータを変数に代入する
      @records = Book.search_for(@content, @method)
    end
  end
end
