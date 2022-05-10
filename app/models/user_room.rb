class UserRoom < ApplicationRecord
  #チャット/DM機能のアソシエーション
  belongs_to :user
  belongs_to :room

end
