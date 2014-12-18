require 'spec_helper'
require 'capybara/rspec'

describe 'sign up page' do

	# before(:all) do
	# end

  it 'prompts the user to sign up' do
    visit '/users/sign_up?'
    page.should have_content('Sign up')
  end

  describe 'unsuccessfully creates a user when' do

    it 'passwords do not match' do
      visit '/users/sign_up?'
      fill_in 'Email', :with => 'capybara@gmail.com'
      fill_in 'Password', :with => 'password'
      fill_in 'Password confirmation', :with => 'cookies?'
      click_button 'Sign up'
      assert page.has_content?('Passwords do not match.')
    end

    it 'password is not long enough' do
      visit '/users/sign_up?'
      fill_in 'Email', :with => 'capybara@gmail.com'
      fill_in 'Password', :with => 'pass'
      fill_in 'Password confirmation', :with => 'pass'
      click_button 'Sign up'
      assert page.has_content?('Password is too short (minimum is 8 characters)')
    end

  end

  it 'successfully creates a user when user information is valid' do
    visit '/users/sign_up?'
    fill_in 'Email', :with => 'capybara@gmail.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password confirmation', :with => 'password'
    click_button 'Sign up'
    # assert page.has_content?('Life Examined')
  end
end