require 'faker'

belief = Belief.new

File.open( 'phrontisteryisms.txt' ).each_with_index do |line, index|
  if index.even?
    belief.name = line
  else
    belief.definition = line
    belief.save!
    belief = Belief.new
  end
end
