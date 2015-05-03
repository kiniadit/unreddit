class PostsController < ApplicationController
  autocomplete :subreddit, :title
  before_filter :authorize
  def index
  end

  def new
    @subreddit_name = Subreddit.find(session[:subreddit_id]).title if session[:subreddit_id]

  end

  def create
  	@post = Post.new(title: post_params["title"], content:post_params["content"])
    @subreddit = Subreddit.find_by(title: post_params[:subreddit_title])
    if @subreddit
      @post.subreddit_id = @subreddit.id
    	@post.user_id = current_user.id
    	if @post.save
    		redirect_to '/'
    	else
        flash[:error] = "Title must have at least 25 characters and content must have at least 100 characters"
    		redirect_to new_user_post_path(current_user)
    	end
    else
      flash[:error] = "Subreddit does not exist!"
      redirect_to new_user_post_path(current_user)
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.content = post_params["content"]
    if @post.save
      redirect_to post_path
    else
      flash[:error] = "Content must have at least 100 characters"
      redirect_to new_user_post_path(current_user)
    end
  end
  def show
    @vote_count_post = PostVote.where(post_id: params[:id]).sum(:vote_val)
    cids = Comment.all.map { |c| c.id}
    @vote_count_arr = cids.map { |cid| CommentVote.where(comment_id: cid).inject(0) {|sum,cv| sum+cv.vote_val}}
  	@post = Post.find(params[:id])
  	@comment = Comment.where(post_id: params[:id])
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to '/'
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :subreddit_title)
  end
end
