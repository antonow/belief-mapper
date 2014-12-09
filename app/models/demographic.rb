class Demographic < ActiveRecord::Base
  belongs_to :user

  validates :age, numericality: { greater_than: 2 }

  after_create do
    self.add_sorted_demographics
  end

  def add_sorted_demographics
  	male = %w(male m)
  	female = %w(female f)
  	none = %w(none unaffiliated n/a na) << ""

  	gender = self.gender.downcase
  	religion = self.religion.downcase

  	if male.include? gender
  		gender = "Male"
  	elsif female.include? gender
  		gender = "Female"
  	end

  	if none.include? religion
  		religion = "None"
  	end

  	if gender == self.gender.downcase
  		gender = self.gender.capitalize
  	end

  	if religion == self.religion.downcase
  		religion = self.religion.capitalize
  	end

  	self.update(gender_sorted: gender, religion_sorted: religion)
  end
end
