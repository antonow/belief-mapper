json.beliefs @beliefs do |belief|
  json.id belief.id
  json.name belief.name
  json.definition belief.definition
  json.count belief.user_count / @divide_by + 3
  if current_user.held_beliefs.include?(belief)
    json.hsl belief.avg_conviction
  else
    json.hsl -1
  end
end

json.connections @connections do |connection|
  json.source connection.belief_1_id
  json.target connection.belief_2_id
  json.value connection.strong_connections / @c_divide_by + 1
end
