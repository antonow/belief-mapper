require 'faker'
include ApplicationHelper


belief = Belief.new

File.open( 'phrontisteryisms.txt' ).each_with_index do |line, index|
  if index.even?
    belief.name = line.chomp
  else
    belief.definition = line.chomp
    belief.save!
    belief = Belief.new
  end
end

10.times do
  demographic = Demographic.create!(:gender => 'f') # ['m', 'f'].sample
  User.create!(:email => Faker::Internet.email, :password => 'password', :password_confirmation => 'password', :demographic => demographic)
end

User.all.each do |user|
  rand(10..20).times do
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

UserBelief.all.each do |ub|
    ub.conviction = rand(1..100)
    ub.save
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


