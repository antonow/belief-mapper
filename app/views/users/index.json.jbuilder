
  json.beliefs @beliefs do |belief|
    json.id belief.id
    json.name belief.name
    json.definition belief.definition
    json.count belief.user_count
    json.hsl belief.user_beliefs.find_by(user: current_user).conviction
  end


  json.connections @connections do |connection|
    json.source connection.belief_1_id
    json.target connection.belief_2_id
    json.value connection.count * 3
  end


