class Book < ApplicationRecord

  has_one_attached :image
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :view_counts, dependent: :destroy
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite' #いいね多い順に投稿表示

  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  #投稿数を日付別に表示
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } #今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } #昨日
  #投稿数を週別に表示
  scope :created_this_week, -> { where(created_at: Time.zone.now.all_week) } #今週
  scope :created_last_week, -> { where(created_at: 1.week.ago.all_week) }#先週


    def favorited_by?(user)
      favorites.exists?(user_id: user.id)
    end
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

end
