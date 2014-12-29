class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
    	t.integer :user_count
    	t.integer :comment_count

      t.timestamps
    end

    create_table :belief_stats do |t|
    	t.belongs_to :stat
    	t.belongs_to :belief
    	t.integer	:user_count
    	t.integer	:avg_conviction
    	t.integer :comment_count

    	t.timestamps
    end
  end
end
