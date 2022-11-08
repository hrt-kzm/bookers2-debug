class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  # メッセージの最大送信文字数の設定
  validates :message, presence: true, length: { maximum: 140 }
  
end
