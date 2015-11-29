require 'rails_helper'

RSpec.describe Sinebow do
  context 'given a number of colours' do
    let!(:rainbow) { Sinebow.new(20).colours }

    it 'returns a rainbow' do
      expect(rainbow.count).to eq(20)
      expect(rainbow).to include a_kind_of Color::RGB
    end

    scenario 'all colours are unique' do
      expect(rainbow.uniq).to match_array(rainbow)
    end
  end
end
