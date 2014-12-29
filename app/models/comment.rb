class Comment < ActiveRecord::Base

  belongs_to :user

  acts_as_taggable
  scope :by_join_date, order("created_at DESC")

  def linkify_comment
    matches = self.body.scan(/\b[A-Za-z]+ism/).sort_by { |ism| ism.length }.reverse
    matches.each do |match|
    	if Belief.all_names.include? (match)
		    belief = Belief.find_by(name: match)
		    self.update(body: self.body.gsub(/(?<!>)#{match}(?!<)/, "<a href='beliefs/#{match}' rel='tooltip' title='#{belief.definition}'>#{match}</a>"))
      else # if this 'ism' doesn' exist in the system yet
		    self.update(body: self.body.gsub(/(?<!>)#{match}(?!<)/, "<a href='#' rel='tooltip' title='This belief is pending'>#{match}</a>"))
		  end
      self.tag_list.add(match)
      self.save
	  end
    # indexes = []
    # matches.each do |match|
    #   start_index = self.body.index(match)
    #   indexes << [self.body.index(match), start_index + match.length]
    # end
    
    # new_body = ""
    # indexes.each do |start, end|
    #   self.body.
  end
end
