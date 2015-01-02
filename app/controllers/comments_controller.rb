class CommentsController < ApplicationController

  def index
    @comment = Comment.new
    @comments = Comment.order('created_at DESC')
  end

  def create
    body = params[:comment][:body]
    unless body.nil? || body.match(/href/)
      @comment = Comment.create!(body: body, user: current_user)
      @comment.linkify_comment

      if params[:belief_id]
        belief = Belief.find(params[:belief_id])
        @comment.tag_list.add(belief.name)
        @comment.save
      end
    end
    @comments = Comment.all.reverse
    # @comment = Comment.new
    redirect_to :back
  end

  def destroy
    Comment.find(params[:id].to_i).destroy
    redirect_to :back
  end

end
