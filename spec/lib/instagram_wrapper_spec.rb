require 'rails_helper'

RSpec.describe InstagramWrapper do
  describe '.profile' do
    let(:profile) { InstagramWrapper.profile(4079668) }
    it 'has the correct attributes' do
      expect(profile['full_name']).to eq('Sam Garson')
      expect(profile['username']).to eq('samtgarson')
    end
  end
end
