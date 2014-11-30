module UsersBeliefsHelper

  def create_connections_for(belief)
    # raise "create_connections_for method only works for beliefs" unless belief.class == Belief
    all_related_beliefs = []
    # For each user it pushes their beliefs into all_related_beliefs array.
    belief.users.each do |user|
      user.beliefs.each do |comparison_belief|
        all_related_beliefs << comparison_belief unless comparison_belief == belief
      end
    end

    all_related_beliefs.each do |related_belief|
      if belief.id < related_belief.id
        first_belief_id = belief.id
        second_belief_id = related_belief.id
      else
        first_belief_id = related_belief.id
        second_belief_id = belief.id
      end
      if @conn = Connection.where(:belief_1_id => first_belief_id, :belief_2_id => second_belief_id).first
        @conn.count += 1
        @conn.save
      else
        Connection.create(belief_1_id: first_belief_id, belief_2_id: second_belief_id)
      end
    end
  end
end
