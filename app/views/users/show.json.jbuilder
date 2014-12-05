json.beliefs @beliefs do |belief|
  json.id belief.id
  json.name belief.name
  json.definition belief.definition
  json.count belief.user_count / 2
  json.hsl -1
end

json.connections @connections do |connection|
  json.source connection.belief_1_id
  json.target connection.belief_2_id
  if connection.count > 5
    json.value connection.count / 3
  else
    json.value 0
  end

end
