require 'rails_helper.rb'

describe 'Hitting the home page', js: true, type: :feature do
  before do
    visit '/'
  end

  it 'has the correct content' do
    expect(page).to have_content('Analyse now')
  end

  it 'redirects to Instagram Login' do
    click_link 'Analyse now'
    expect(page).to have_css 'input[value="Log in"]'
  end
end
