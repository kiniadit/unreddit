class Subreddit < ActiveRecord::Base
	validates :title, uniqueness: true, length: {minimum: 3}
	validates_format_of :title, :with => /\A(^[A-Za-z0-9]+$)\z/
	has_many :posts, dependent: :destroy
	has_many :subscribers, dependent: :destroy
	has_many :users, through: :subscribers
end
