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
        belief = Belief.find(params[:belief_id].to_i)
        @comment.tag_list.add(belief.name)
      end

      unless params[:comment_id].nil? || params[:comment_id] == ""
        parent_comment = Comment.find(params[:comment_id].to_i)
        parent_comment.replies << @comment
        @comment.tag_list.add(parent_comment.tag_list)
      end

      @comment.save
      @comment.linkify_comment

    end
    @comments = Comment.all.reverse
    # @comment = Comment.new
    redirect_to :back
  end

  def destroy
    comment = Comment.find(params[:id].to_i)
    
    comment.tags.each do |tag|
      tag.taggings_count -= 1
      if tag.taggings_count <= 0
        tag.destroy
      end
    end

    comment.destroy
      
    redirect_to :back
  end

  def form
    @reply_to = params[:comment_id]
    render :partial => "form"
  end

end
