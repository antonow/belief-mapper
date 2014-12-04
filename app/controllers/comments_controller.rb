class CommentsController < ApplicationController

  def index
    @comment = Comment.new
    @comments = Comment.all.reverse
  end

  def create
    if params[:comment][:title] != nil
      @comment = Comment.create!(title: params[:comment][:title], body: params[:comment][:body], user: current_user)
      @comment = Comment.new
    else
      @comment = Comment.new(body: params[:body])
    end
    @comments = Comment.all.reverse
    render 'index'
  end

end
