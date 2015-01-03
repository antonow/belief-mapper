class AddCommentRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :comment, index: true
		remove_column :comments, :title
  end
end
