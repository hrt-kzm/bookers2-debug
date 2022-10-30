class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  #　検索条件の分岐
  def self.search_for(content, method)
    # 完全一致の場合
    if method == 'perfect'
      # 入力内容と'title'が一致するデータを取得する
      Book.where(title: content)
    # 前方一致の場合
    elsif method == 'forward'
      # 入力内容の文字列から始まるデータを取得する
      Book.where('title LIKE ?', "#{content}%")
    # 後方一致の場合
    elsif method == 'backward'
      #入力内容の文字列で終わるデータを取得する
      Book.where('title LIKE ?', "%#{content}")
    # それ以外(部分一致)の場合
    else
      # 入力内容を含むデータを取得する
      Book.where('title LIKE ?', "%#{content}%")
    end
  end
      
  
  def favorited_by?(user) # favoritesテーブル内に引数で渡されたユーザーidが存在するかを調べる
    favorites.exists?(user_id: user.id)
  end
end
