class Relationship < ApplicationRecord
  
  belongs_to :follower, class_name: "User" #Userモデルをfollowerモデルとして参照できる
  belongs_to :followed, class_name: "User" #Userモデルをfollowedモデルとして参照できる
  
end
