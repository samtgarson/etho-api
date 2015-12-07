require 'rails_helper.rb'

describe 'Hitting the home page', js: true, type: :feature do
  it 'has the correct content' do
    visit '/'

    expect(page).to have_content('Instagram Login')
  end
end
