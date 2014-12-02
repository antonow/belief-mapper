class Belief < ActiveRecord::Base
  belongs_to :category
  has_many :user_beliefs, -> { includes(:users) }
  has_many :users, through: :user_beliefs
  has_many :demographics, through: :users
  has_many :connections, foreign_key: 'belief_1_id'
  has_many :connections, foreign_key: 'belief_2_id'

  def self.search(query)
    where("definition like ? OR name like ?", "%#{query}%", "%#{query}%")
  end

  def find_stats(query, value)
    raise User.where(belief: self)
    user_beliefs = UserBelief.all.where(belief: self)
    user_beliefs.where(user.demographic.eval(query) + ' = ?', value)
    # demographics = []
    # user_beliefs.all.each do |user_belief|
    #   demographics << user_belief.user.demographic
    # end

    # demographics.where(query + ' = ?', value).count
  end



  def stats_for(query, value)
    return self.demographics.where(query.to_sym => value).count
  end

  # For connections models find where the belief is either belief1 or belief2
  # Sort them by count and list them.

  def list_top_connections
    connections = Connection.includes(:belief_1, :belief_2).where("belief_1_id = ? OR belief_2_id = ?", self.id, self.id).order('count DESC')
    connection_count = {}
    connections.each do |connection|
      if connection.belief_1_id != self.id
        belief_id = connection.belief_1_id
      else
        belief_id = connection.belief_2_id
      end
      connection_count[belief_id] = connection.count
    end

    linked_belief_ids = connection_count.keys
    linked_beliefs = Belief.find(linked_belief_ids)

    output_hash = {}
    linked_beliefs.each do |belief|
      output_hash[belief] = connection_count[belief.id]
    end
    return Hash[output_hash.sort {|a,b| b[1]<=>a[1]}]
  end







end
