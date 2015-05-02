class SubredditsController < ApplicationController
	def index
		@subreddits = Subreddit.all
	end
	def show
		@subreddit = Subreddit.find(params[:id])
		session[:subreddit_id] = params[:id]
		@subscriber_count = Subscriber.where(subreddit_id: params[:id]).count
		pids = Post.where(subreddit_id: params[:id]).map { |p| p.id}
  		@vote_count_arr = pids.map { |pid| PostVote.where(post_id: pid).inject(0) {|sum,pv| sum+pv.vote_val}}
  		@posts = Post.where(subreddit_id: params[:id])
  	end
end
