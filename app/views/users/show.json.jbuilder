json.beliefs @beliefs do |belief|
  json.id belief.id
  json.name belief.name
  json.definition belief.definition
  json.count belief.user_count / @divide_by + MIN_BELIEF_SIZE
  if current_user.held_beliefs.include?(belief)
    json.hsl belief.user_beliefs.find_by(user: current_user).conviction
  else
    json.hsl -1
  end
end

json.connections @connections do |connection|
  json.source connection.belief_1_id
  json.target connection.belief_2_id
  json.value connection.count / @c_divide_by + MIN_CONN_SIZE
end
