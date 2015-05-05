class Post < ActiveRecord::Base
  profanity_filter :title, :content, :method => 'hollow'
  validates :title, length: {minimum: 25, maximum: 300}
  validates :content, allow_blank: true, length: { minimum: 100, maximum: 40000}
  validates :link, allow_blank: true, format: {with: URI.regexp}
  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :subreddit
end
