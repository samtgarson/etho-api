require 'rails_helper'

RSpec.describe Image, type: :model do
  describe '.video?' do
    let(:video) { FactoryGirl.build(:image, type: 'video') }
    let(:image) { FactoryGirl.build(:image, type: 'image') }

    context 'given a video' do
      it 'returns true' do
        expect(video.video?).to be_truthy
      end
    end

    context 'given an image' do
      it 'returns false' do
        expect(image.video?).to be_falsey
      end
    end
  end
end
