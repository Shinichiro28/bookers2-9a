class Room < ApplicationRecord
  #チャット/DM機能のアソシエーション
  has_many :chats
  has_many :user_rooms

end
