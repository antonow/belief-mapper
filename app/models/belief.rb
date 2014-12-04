class Belief < ActiveRecord::Base
  belongs_to :category
  has_many :user_beliefs, -> { includes(:user) }
  has_many :users, through: :user_beliefs
  has_many :demographics, through: :users

  include ApplicationHelper

  def self.search(query)
    where("definition like ? OR name like ?", "%#{query}%", "%#{query}%")
  end

  def stat_for(category, value)
    self.demographics.where(category => value).count
  end

  def all_stats_for(category)
    results = {}
    return_list_for(category).each do |value|
      results[value] = stat_for(category, value)
    end
    results
  end

  def all_the_stats
    results = {}
    all_categories.each do |category|
      results[category] = all_stats_for(category)
    end
    results
  end

  def list_top_connections
    top_connections = Connection.connected_belief_strengths(self)[0..9]
    passed_connections = []
    top_connections.each do |conn|
      passed_connections << [conn[0].name.capitalize, conn[0].user_count]
    end
     passed_connections.sort
  end

  def strong_convictions
    self.user_beliefs.where('conviction > 50').to_a
  end

  def belief_demographics
    demo_array = []
    self.strong_convictions.each do |ub|
      demo_array << ub.user.demographic
    end
    return demo_array
  end

  def group_demographics_by_age
    data_array = []
    self.belief_demographics.each do |demo|
      data_array << [demo.age, 1]
    end
    return data_array
  end

  def group_demographics_by_gender
    data_array = []
    self.belief_demographics.each do |demo|
      data_array << [demo.gender, 1]
    end
    return data_array
  end

  def group_demographics_by_religion
    data_array = []
    self.belief_demographics.each do |demo|
      data_array << [demo.religion]
    end
    data_array = data_array.group_by {|i| i}.values
    return data_array
  end


  def top_connections_links
    top_connections = Connection.connected_belief_strengths(self)[0..9]
    link_connections = []
    top_connections.each do |conn|
      link_connections << [conn[0].name.capitalize, conn[0].id]
    end
     link_connections.sort
  end

  def rank
    Belief.order('user_count DESC').index(self)
  end

  def self.total_beliefs
    all.count
  end
end
