require 'rails_helper'

RSpec.describe Palette, type: :model do
  describe '.new_from_url' do
    context 'given an image' do
      subject(:palette) { Palette.new_from_url(image_url) }
      let(:image_url) { 'spec/fixtures/test_image.jpg' }
      let(:scores) { palette.scores }
      let(:primary) { palette.primary }

      it 'returns a valid palette' do
        expect(palette).to be_a Palette
        expect(palette).to be_valid
      end

      it 'has valid scores' do
        expect(scores).to include a_kind_of Hash
        expect(scores).to all include(:score, :hex)
      end

      it 'has a valid primary colour' do
        expect(primary).to be_a String
        expect(primary.length).to eq 6
      end
    end
  end
end
