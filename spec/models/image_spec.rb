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

  describe '#process_colours' do
    before do
      allow(Palette)
        .to receive(:new_from_url)
        .and_return(FactoryGirl.build(:palette))
    end

    let(:image) { FactoryGirl.build(:image) }
    it 'creates a new palette after save' do
      image.save
      expect(image.palette).to be_a Palette
    end
  end
end
