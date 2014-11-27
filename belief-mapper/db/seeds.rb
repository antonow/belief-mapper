require 'faker'

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
  User.create!(:email => Faker::Internet.email, :password => 'password', :password_confirmation => 'password')
end

User.all.each do |user|
  rand(30..50).times do
    belief = Belief.all.sample
    user.beliefs << belief unless user.beliefs.include?(belief)
  end
end
