class UsersController < ApplicationController
	def new
	end

	def create
		user = User.new(user_params)
	    if user.save
	      session[:user_id] = user.id
	      redirect_to '/'
	    else
	      redirect_to '/signup'
	    end
	end 

	def show
		@posts = Post.where(user_id: session[:user_id])
		@comments = Comment.where(user_id: session[:user_id])
		@subscriptions = Subscriber.where(user_id: session[:user_id])
		@activity_feed = @posts + @comments + @subscriptions
		@activity_feed.sort_by!(&:created_at)
		p @activity_feed[0].model_name.human
	end  
	private

	  def user_params
	    params.require(:user).permit(:name, :email, :password, :password_confirmation)
	  end

end
