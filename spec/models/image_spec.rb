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

    let(:new_image) { FactoryGirl.build(:image) }
    let(:old_image) { FactoryGirl.build(:image, :processed) }

    context 'for a new image' do
      it 'creates a new palette' do
        expect(Palette).to receive :new_from_url
        new_image.process_colours
        expect(new_image.palette).to be_a Palette
      end
    end
    context 'for an image which has a colour' do
      it 'returns the existing palette' do
        expect(Palette).not_to receive :new_from_url
        old_image.process_colours
        expect(old_image.palette).to eq old_image.palette
      end
    end
  end

  describe '#season' do
    sample_dates = {
      spring: DateTime.new(2015, 3, 12),
      summer: DateTime.new(2015, 7, 15),
      autumn: DateTime.new(2015, 10, 10),
      winter: DateTime.new(2015, 1, 1)
    }

    sample_dates.each do |season, date|
      image = FactoryGirl.build(:image, created_at: date)

      it 'returns the correct season' do
        expect(image.season).to eq season
      end
    end
  end
end
