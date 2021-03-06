class PostsController < ApplicationController
  def index
    @posts = Post.all
    @post = Post.new
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find_by(uuid: params[:id])
    @comments = Comment.where(post_id: @post).order("created_at DESC")
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      flash[:danger] = "Please log in"
      redirect_to user_path(current_user)
    end
  end

  def edit
    @post = Post.find_by(uuid: params[:id])
  end

  def update
    @post = Post.find_by(uuid: params[:id])

    if @post.update(params[:post].permit(:title, :body))
      redirect_to @post
    else
      flash[:danger] = "Post did not update"
      render 'edit'
    end
  end

  def destroy
    @post = Post.find_by(uuid: params[:id])
    @post.destroy
    redirect_to user_path(current_user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :user_id, :uuid)
  end
end
