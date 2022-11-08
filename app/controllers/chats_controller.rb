class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]
  
  def show
    @user = User.find(params[:id])
    # ログインしているユーザーに紐づいているuser_roomsテーブルのroom_idカラムの値を配列として取得し、変数に渡す
    rooms = current_user.user_rooms.pluck(:room_id)
    #userroomsテーブルから上記で取得したデータと一致するレコードを取得し、変数に渡す
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    # 一致するレコードがない(チャットルームがない)場合
    unless user_rooms.nil?
      # 偽(存在する)場合、user_roomsテーブルに紐づいているroomの値を変数に渡す
      @room = user_rooms.room
    else
      # 真(存在しない)場合、新しくチャットルームを作成し、保存する
      @room = Room.new
      @room.save
      # 自分側のuser_roomsテーブルを作成
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      # 相手側のuser_roomsテーブルを作成
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    # チャット一覧を表示するための変数を用意
    @chats = @room.chats
    # 投稿したチャットを格納するための変数を用意
    @chat = Chat.new(room_id: @room.id)
  end
  
  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save
  end
  
  private
  
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
  
  # 相互フォローしているかどうかの確認
  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
end
