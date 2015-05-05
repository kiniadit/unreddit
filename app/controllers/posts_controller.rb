class PostsController < ApplicationController
  autocomplete :subreddit, :title
  before_filter :authorize
  def index
  end

  def new
    p @link_flag = true if params[:more_params] == "link"
    @subreddit_name = Subreddit.find(session[:subreddit_id]).title if session[:subreddit_id]
  end

  def create
  	@post = Post.new(title: post_params["title"], content: post_params["content"]) if post_params["content"]
    @post = Post.new(title: post_params["title"], link: post_params["link"]) if post_params["link"]
    @subreddit = Subreddit.find_by(title: post_params[:subreddit_title])
    if @subreddit
      @post.subreddit_id = @subreddit.id
    	@post.user_id = current_user.id
    	if @post.save
    		redirect_to '/'
    	else
        flash[:error] = "Title must have at least 25 characters and content must have at least 100 characters"
    		redirect_to new_user_post_path(current_user, :more_params => "link")
    	end
    else
      flash[:error] = "Subreddit does not exist!"
      redirect_to new_user_post_path(current_user, :more_params => "link")
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.content = post_params["content"] if post_params["content"]
    @post.link = post_params["link"] if post_params["link"]
    if @post.save
      redirect_to post_path
    else
      flash[:error] = "Content must have at least 100 characters" if post_params["content"]
      flash[:error] = "Link not valid" if post_params["content"]
      redirect_to new_user_post_path(current_user)
    end
  end
  def show
    @vote_count_post = PostVote.where(post_id: params[:id]).sum(:vote_val)
    cids = Comment.all.map { |c| c.id}
    @vote_count_arr = cids.map { |cid| CommentVote.where(comment_id: cid).inject(0) {|sum,cv| sum+cv.vote_val}}
  	@post = Post.find(params[:id])
  	@comment = Comment.where(post_id: params[:id])
    @vote_val = PostVote.where(user_id: session[:user_id], post_id: @post.id).first.vote_val if PostVote.exists?(user_id: session[:user_id], post_id: @post.id)  
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to '/'
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :subreddit_title, :more_params, :link)
  end

end
