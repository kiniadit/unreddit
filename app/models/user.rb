class User < ActiveRecord::Base
	validates :email, presence: true, uniqueness: true
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates :name, presence: true
	validates :password, presence: true
	has_secure_password
	has_many :posts, dependent: :destroy
	has_many :subscribers, dependent: :destroy
	has_many :subreddits, through: :subscribers
end
