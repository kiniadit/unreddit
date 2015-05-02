class User < ActiveRecord::Base
	has_secure_password
	has_many :posts
	has_many :subscribers
	has_many :subreddits, through: :subscribers
end
