class CommentsController < ApplicationController

  def index
    @comment = Comment.new
    @comments = Comment.all.reverse
  end

  def create
    body = params[:comment][:body]
    unless body.nil? || body.match(/href/)
      if params[:comment][:title] != nil
        @comment = Comment.create!(title: params[:comment][:title], body: body, user: current_user)
        @comment.linkify_comment
      else
        @comment = Comment.create!(body: body, user: current_user)
        @comment.linkify_comment
      end

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



end
