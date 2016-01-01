require 'rails_helper.rb'

describe 'Hitting the home page', js: true, type: :feature do
  before do
    visit '/'
  end

  it 'has the correct content' do
    expect(page).to have_content('Instagram Login')
  end

  it 'redirects to Instagram Login' do
    click_link 'Instagram Login'
    expect(page).to have_css 'input[value="Log in"]'
  end
end
