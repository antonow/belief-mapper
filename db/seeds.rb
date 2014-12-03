require 'faker'
include ApplicationHelper
include UsersBeliefsHelper



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

50.times do
  demographic = Demographic.create!(:gender => all_genders.sample, :age => rand(5..110), :religion => all_religions.sample, :country => "USA", :state => all_states.sample, :education_level => all_education_levels.sample)
  User.create!(:email => Faker::Internet.email, :password => 'password', :password_confirmation => 'password', :demographic => demographic)
end

User.all.each do |user|
  rand(20..40).times do
    belief = Belief.all.sample
    user_belief = UserBelief.create!(belief: belief, conviction: rand(0..100), user: user)
    if user_belief.conviction > 5
      generate_new_connections(user_belief)
      belief.user_count += 1
    end
    belief.save
  end
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
