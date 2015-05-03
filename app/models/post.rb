class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :content, presence: true
  has_many :comments
  belongs_to :user
  belongs_to :subreddit
end
