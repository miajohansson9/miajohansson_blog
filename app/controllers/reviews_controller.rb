class ReviewsController < ApplicationController
  before_action :find_review, only: [:update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource
  layout "minimal"

  def index
    if params[:post].present?
      @post = Post.friendly.find(params[:post])
      set_meta_tags :title => "Editor Feedback for #{@post.title}"
    elsif (current_user.admin?) || (current_user.editor?)
      if current_user.admin?
        @all_reviews = Post.all.in_review.order("updated_at desc")
      end
      @editors_reviews = Post.all.in_review.where(:reviews => {editor_id: current_user.id}).order("updated_at desc")
      @submitted_for_review = Post.all.submitted.order("updated_at desc")
      @submitted_pitches = Pitch.is_submitted.order("updated_at desc")
      set_meta_tags :title => "Edit | The Teen Magazine"
    else
      redirect_to user_path(current_user), notice: "You are not allowed access to editor reviews."
    end
  end

  def update
    @review.update(review_params)
  end

  def destroy
    @review.destroy
    redirect_to :back, notice: "The review was successfully deleted."
  end

  private

  def review_params
    params.require(:review).permit(:created_at, :updated_at, :status, :post_id, :editor_id, :active, :notes)
  end

  def find_review
    @review = Review.find(params[:id])
  end
end
