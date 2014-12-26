class ChangeCommentBodyToText < ActiveRecord::Migration
  def change
  	change_column :comments, :body, :text
  	add_column		:comments, :votes, :integer
  end
end
