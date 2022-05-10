class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 has_many :books, dependent: :destroy
 has_many :book_comments, dependent: :destroy
 has_many :favorites, dependent: :destroy
 has_many :view_counts, dependent: :destroy

 #フォローしている人の取得
 has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
 #フォローされている人の取得
 has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
 #自分がフォローしている人
 has_many :followings, through: :relationships, source: :followed
 #自分をフォローしてくれている人
 has_many :followers, through: :reverse_of_relationships, source: :follower
 #チャット/DM機能
 has_many :user_rooms, dependent: :destroy
 has_many :chats, dependent: :destroy
 has_many :rooms, through: :user_rooms

 has_one_attached :profile_image

 validates :name, uniqueness: true, length: {minimum: 2, maximum: 20 }
 validates :introduction, length: { maximum: 50 }

    def get_profile_image
      (profile_image.attached?) ? profile_image : 'no_image.jpg'
    end

    #フォローした時の処理
    def follow(user)
      relationships.create(followed_id: user.id)
    end

    #フォロー外す時の処理
    def unfollow(user)
      relationships.find_by(followed_id: user.id).destroy
    end

    #フォローしているかを判定
    def following?(user)
      followings.include?(user)
    end

  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?","#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

end
