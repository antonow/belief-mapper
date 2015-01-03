class CommentsController < ApplicationController

  def index
    @comment = Comment.new
    @comments = Comment.where(reply_to: nil ).order('created_at DESC')
  end

  def create
    body = params[:comment][:body]
    unless body.nil? || body.match(/href/)
      @comment = Comment.create!(body: body, user: current_user)
      
      if params[:belief_id]
        belief = Belief.find(params[:belief_id])
        @comment.tag_list.add(belief.name)
      end

      unless params[:comment_id] == ""
        parent_comment = Comment.find(params[:comment_id])
        parent_comment.replies << @comment
        @comment.tag_list.add(parent_comment.tag_list)
      end

      @comment.linkify_comment
      # @comment.save

    end
    @comments = Comment.all.reverse
    # @comment = Comment.new
    redirect_to :back
  end

  def destroy
    Comment.find(params[:id].to_i).destroy
    redirect_to :back
  end

  def form
    @reply_to = params[:comment_id]
    render :partial => "form"
  end

end
