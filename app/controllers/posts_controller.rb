class PostsController < ApplicationController
  before_action :set_post, only: %i[ likes show edit update destroy comment ]

  # GET /posts or /posts.json
  def index
    @posts = Post.for_followers_and_user(current_user).includes(:user, {comments: :user, attachment: {file_attachment: :blob}}).
              order(created_at: :desc)
    @current_user_likes = @posts.eager_load(:likes).user_likes(current_user)

  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.build_attachment
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_url, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html do
          @post.build_attachment
          render :new, status: :unprocessable_entity

        end
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_url, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def likes
    like = @post.likes.find_by_user_id(current_user.id)
    if like
      like.destroy!
      respond_to do |format|
        format.json { render json: { liked: false, total_likes: @post.likes.count } }
      end
    else
      @post.likes.build(user_id: current_user.id).save
      respond_to do |format|
        format.json { render json: { liked: true, total_likes: @post.likes.count} }
      end
    end 
  end

  def comment
    @post.comments.build(comment_params).save
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Comment has been created" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params[:post][:user_id] = current_user.id
      params.require(:post).permit(:title, :body, :user_id, attachment_attributes: [:file])
    end

    def comment_params
      params[:comment][:user_id] = current_user.id
      params.require(:comment).permit(:user_id, :content)
    end
end
