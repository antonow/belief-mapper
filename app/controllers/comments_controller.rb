class CommentsController < ApplicationController

  def index
    @comment = Comment.new
    @comments = Comment.all
  end

  def create
    if params[:comment][:title] != nil
      @comment = Comment.create!(title: params[:comment][:title], body: params[:comment][:body], user: current_user)
    else
      @comment = Comment.new(body: params[:body])
    end
    @comments = Comment.all
    render 'index'
  end

end
