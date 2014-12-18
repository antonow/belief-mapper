require 'spec_helper'
require 'capybara/rspec'

describe 'home page' do

	# before(:all) do
	# end

  it 'asks the user a question' do
		allow_message_expectations_on_nil
    # allow(@belief).to receive(Belief.create!(:name => "cookieism", :definition => "belief that cookies are the best"))
    allow(@belief).to receive(:definition).and_return("belief that cookies are the best")
    allow(@belief).to receive(:id).and_return(1)

    visit '/'
    page.should have_content('Do you believe')
  end
end