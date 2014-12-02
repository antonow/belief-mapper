require 'faker'
include ApplicationHelper


belief = Belief.new
# 'phrontisteryisms.txt'
category = ""
File.open( 'refactored_isms.txt' ).each_with_index do |line, index|
  text = line.chomp
  if index.even?
    if text[0] == "*"
      belief.starred = true
      belief.name = text[1..-1]
    else
      belief.name = text
    end
  else
    if ["Religion", "Philosophy", "Politics", "Other"].include?(text)
      category = Category.create!(name: text)
    else
      belief.definition = text
      belief.category = category
      belief.save!
      belief = Belief.new
    end
  end
end

30.times do
  demographic = Demographic.create!(:gender => ['Male', 'Female'].sample, :age => rand(5..110), :religion => )
  User.create!(:email => Faker::Internet.email, :password => 'password', :password_confirmation => 'password', :demographic => demographic)
end

User.all.each do |user|
  rand(20..40).times do
    belief = Belief.all.sample
    user_belief = UserBelief.create!(belief: belief, conviction: rand(0..100), user: user)
    # user.beliefs << belief unless user.beliefs.include?(belief)
    belief.user_count += 1
    belief.save
  end
end

# Creates connections between beliefs based on how many users have the same connection in common
Belief.all.each do |belief|
  create_connections_for(belief)
end


Belief.all.each do |belief|
  if belief.user_beliefs.count > 0
    total = 0
    belief.user_beliefs.each do |ub|
      total += ub.conviction
    end
    belief.avg_conviction = total/belief.user_beliefs.count
  else belief.avg_conviction = 0
  end
  belief.save
end

# Creates categories
# Category.create!(name: "Philosophy")
# Category.create!(name: "Politics")
# Category.create!(name: "Religion")




