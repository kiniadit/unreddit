class Subreddit < ActiveRecord::Base
	has_many :posts
	has_many :subscribers
	has_many :users, through: :subscribers
end
