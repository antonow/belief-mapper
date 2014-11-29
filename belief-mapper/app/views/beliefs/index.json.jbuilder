json.beliefs @beliefs do |belief|
  json.id belief.id
  json.name belief.name
  json.definition belief.definition
  json.count belief.user_count

end

  json.connections @connections do |connection|
  json.source connection.belief_1_id
  json.target connection.belief_2_id
  json.value connection.count

end