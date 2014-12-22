class AddAnsweredQuestionsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :answered_questions, :integer, :default => 0
  end
end
