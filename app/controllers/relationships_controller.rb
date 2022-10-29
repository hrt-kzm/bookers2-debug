class RelationshipsController < ApplicationController
  
  def create
    current_user.follow(params[:user_id]) #urlに表示されているユーザーidを取得し、ログインしているユーザーidをfollower_idとしてフォローした人のfollowed_idと紐付け、relationshipsテーブルに保存する
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    current_user.unfollow(params[:user_id]) #urlに表示されているユーザーidを取得し、ログインしているユーザーに紐づいているfollowed_idを削除し、フォローを解除する
    redirect_back(fallback_location: root_path)
  end
  
  def following_user #フォロー一覧
    user = User.find(params[:user_id])
    @users = user.following_user
  end
  
  def followed_user #フォロワー一覧
    user = User.find(params[:user_id])
    @users = user.follow_user
  end
  
end
