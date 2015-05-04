class Post < ActiveRecord::Base
  validates :title, presence: true, length: {minimum: 25}
  validates :content, presence: true, length: { minimum: 100 }
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :subreddit
end
