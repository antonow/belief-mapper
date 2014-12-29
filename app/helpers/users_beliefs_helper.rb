module UsersBeliefsHelper

  def generate_new_connections(user_belief, options={})
    default_options = {
      :down => :false
    }
    if user_belief.conviction > 5
      new_belief_id = user_belief.belief.id
      user_belief.user.user_beliefs.where('conviction > ?', 5).each do |other_belief|
        other_id = other_belief.belief_id
        unless new_belief_id == other_id
          if new_belief_id < other_id
            first_belief_id = new_belief_id
            second_belief_id = other_id
          else
            first_belief_id = other_id
            second_belief_id = new_belief_id
          end

          if options[:down]
            @conn = Connection.find_by(:belief_1_id => first_belief_id, :belief_2_id => second_belief_id)
            @conn.count -= 1
            if user_belief.conviction >= 50 && UserBelief.find_by(user: user_belief.user, belief_id: other_id).conviction > 50
              @conn.strong_connections -= 1 
            end
          else
            @conn = Connection.find_or_create_by(:belief_1_id => first_belief_id, :belief_2_id => second_belief_id)
            @conn.count += 1
            if user_belief.conviction >= 50 && UserBelief.find_by(user: user_belief.user, belief_id: other_id).conviction > 50
              @conn.strong_connections += 1 
            end
          end
            
          @conn.save
          puts "======================================"
        end
      end
    end
  end

  def destroy_connections_for(user_belief)
    current_id = user_belief.belief.id
    user_belief.user.user_beliefs.where('conviction > ?', 5).each do |other_belief|
      other_id = other_belief.belief_id
      unless current_id == other_id
        if current_id < other_id
          first_belief_id = current_id
          second_belief_id = other_id
        else
          first_belief_id = other_id
          second_belief_id = current_id
        end
        @conn = Connection.find_or_create_by(:belief_1_id => first_belief_id, :belief_2_id => second_belief_id)
        @conn.count -= 1
        if user_belief.conviction >= 50 && UserBelief.find_by(user: user_belief.user, belief_id: other_id).conviction > 50
          @conn.strong_connections += 1
        end
      end
    end
  end

end
  # def create_connections_for(belief)
  #   # raise "create_connections_for method only works for beliefs" unless belief.class == Belief
  #   all_related_beliefs = []
  #   # For each user it pushes their beliefs into all_related_beliefs array.
  #   belief.users.each do |user|
  #     user.beliefs.each do |comparison_belief|
  #       all_related_beliefs << comparison_belief unless comparison_belief == belief
  #     end
  #   end

  #   all_related_beliefs.each do |related_belief|
  #     if belief.id < related_belief.id
  #       first_belief_id = belief.id
  #       second_belief_id = related_belief.id
  #     else
  #       first_belief_id = related_belief.id
  #       second_belief_id = belief.id
  #     end
  #     if @conn = Connection.where(:belief_1_id => first_belief_id, :belief_2_id => second_belief_id).first
  #       @conn.count += 1
  #       @conn.save
  #     else
  #       Connection.create(belief_1_id: first_belief_id, belief_2_id: second_belief_id)
  #     end
  #   end
  # end

