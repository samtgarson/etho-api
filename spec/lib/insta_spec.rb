require 'rails_helper'

RSpec.describe Insta do
  describe '.instagram_id_for' do
    stub_out_instagram_api

    let(:opts) do
      {
        code: 'valid_code',
        redirect: '123'
      }
    end
    let!(:output) { Insta.instagram_id_for(opts) }

    it 'returns an id' do
      expect(output).to eq(example_user[:id].to_i)
      expect(output).to be_an Integer
    end

    it 'assigns the access token' do
      expect(Insta.access_token).not_to be_nil
    end
  end

  describe '.profile' do
    stub_out_instagram_api

    subject(:profile) { Insta.profile }

    it 'returns a user' do
      expect(profile).to be_a User
      expect(profile).to be_valid
    end

    it 'has the correct attributes' do
      expect(profile[:_id]).to eq example_user[:id].to_i
      expect(profile[:full_name]).to eq example_user[:full_name]
    end
  end

  describe '.user_images' do
    stub_out_instagram_api

    let(:images) { Insta.user_images(nil) }

    it 'recursively fetches images' do
      expect(images.count).to eq 2
      expect(images).to all be_an Image
    end
  end

  describe '.image' do
    stub_out_instagram_api

    before do
      FactoryGirl.create(:user, example_user)
    end
    let(:image) { Insta.image(123) }

    it 'returns an image' do
      expect(image).to be_an Image
      expect(image).to be_valid
    end

    it 'has parses the tags correctly' do
      expect(image[:tags].count).to eq example_image[:tags].count
      expect(image[:tags]).to include a_kind_of Symbol
    end

    it 'has the correct attributes' do
      expect(image[:likes]).to eq example_image[:likes][:count].to_i
      expect(image[:comments]).to eq example_image[:comments][:count].to_i
      expect(image[:type]).to be_a Symbol
    end

    it 'converts the attributes correctly' do
      expect(image.tagged_users).to include a_kind_of User
      expect(image.created_at).to be_a DateTime
    end
  end
end
