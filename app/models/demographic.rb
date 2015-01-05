class Demographic < ActiveRecord::Base
  belongs_to :user

  validates :age, numericality: { greater_than: 2,
                                  less_than: 125 }

  after_create do
    self.add_sorted_demographics
  end

  def add_sorted_demographics
    # Demographic.all.each(&:add_sorted_demographics)
    # to run in Rails C
    
  	male = %w(male m)
  	female = %w(female f)
  	none = %w(none unaffiliated n/a na) << ""
    mormon = ["church of jesus christ of latter-day saints (mormon)"]
    catholic = ["christian-catholic"]
    hindu = %(hinduism)
    christian = %(christianity)
    buddhist = %(buddhism)

  	gender = self.gender.downcase
  	religion = self.religion.downcase

  	if male.include? gender
  		gender = "Male"
  	elsif female.include? gender
  		gender = "Female"
  	end

  	if none.include? religion
  		religion = "None"
    elsif mormon.include? religion
      religion = "Mormon"
    elsif catholic.include? religion
      religion = "Catholic"
    elsif hindu.include? religion
      religion = "Hindu"
    elsif christian.include? religion
      religion = "Christian"
    elsif buddhist.include? religion
      religion = "Buddhist"
  	end

    if gender == ""
      gender = nil
  	elsif gender == self.gender.downcase
  		gender = self.gender.capitalize
  	end

    if religion == ""
      religion = nil
  	elsif religion == self.religion.downcase
  		religion = self.religion.capitalize
  	end

  	self.update(gender_sorted: gender, religion_sorted: religion)
  end
end
