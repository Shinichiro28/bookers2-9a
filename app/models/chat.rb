class Chat < ApplicationRecord
  #チャット/DM機能のアソシエーション
  belongs_to :user
  belongs_to :room

  validates :message, presence: true, length: { maximum: 140 }
end
