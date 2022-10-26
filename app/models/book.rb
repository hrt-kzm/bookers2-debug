class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def favorited_by?(user) # favoritesテーブル内に引数で渡されたユーザーidが存在するかを調べる
    favorites.exists?(user_id: user.id)
  end
end
