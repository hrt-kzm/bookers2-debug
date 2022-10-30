class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #Relationshipモデルをfollowerモデルとして参照できる。フォローしている人を取得
  has_many :following_user, through: :follower, source: :followed #自分がフォローしている人と紐づく、@following.userと記述することでフォローしている人の一覧を表示できるようになる
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #Relationshipモデルをfollowedモデルとして参照できる。フォローされている人を取得
  has_many :follow_user, through: :followed, source: :follower #自分をフォローしている人と紐づく、@follow_userと記述することでフォローされている人の一覧を表示することができる
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user_id) #ユーザーをフォローするメソッドの定義
    follower.create(followed_id: user_id) #followed_idにuser_idを紐付けて、relationshipsテーブルに保存する
  end

  def unfollow(user_id) #フォローを外すメソッドの定義
    follower.find_by(followed_id: user_id).destroy #relationshipsテーブルのfollowed_idとuser_idが一致するデータを削除する
  end

  def following?(user) #フォロー済みかの確認を行うメソッドの定義
    following_user.include?(user)
  end
  
  #　検索条件の分岐
  def self.search_for(content, method)
    # 完全一致の場合
    if method == 'perfect'
      # 入力内容と'title'が一致するデータを取得する
      User.where(name: content)
    # 前方一致の場合
    elsif method == 'forward'
      # 入力内容の文字列から始まるデータを取得する
      User.where('name LIKE ?', "#{content}%")
    # 後方一致の場合
    elsif method == 'backward'
      #入力内容の文字列で終わるデータを取得する
      User.where('name LIKE ?', "%#{content}")
    # それ以外(部分一致)の場合
    else
      # 入力内容を含むデータを取得する
      User.where('name LIKE ?', "%#{content}%")
    end
  end
  
end
