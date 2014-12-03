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
     passed_connections
  end


  def top_connections_links
    top_connections = Connection.connected_belief_strengths(self)[0..9]
    link_connections = []
    top_connections.each do |conn|
      link_connections << [conn[0].id, conn[0].name.capitalize]
    end
     link_connections
  end

  def rank
    Belief.order('user_count DESC').index(self)
  end

  def self.total_beliefs
    all.count
  end
end
