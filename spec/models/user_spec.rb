require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without full name' do
    expect(FactoryGirl.build(:user, full_name: nil)).to be_invalid
  end

  before do
    allow(Insta).to receive_messages(
      profile: FactoryGirl.build(:user, _id: 123456),
      user_images: FactoryGirl.build_list(:image, 5))
  end

  describe '#update_if_required' do
    let!(:stale_user) { FactoryGirl.create(:user, updated_at: 3.days.ago, _id: 123456) }
    let!(:fresh_user) { FactoryGirl.create(:user, updated_at: Time.now) }

    context 'given a stale user' do
      it 'should update the user' do
        expect { stale_user.update_if_required }.to change { stale_user.full_name }
        expect(stale_user.images.count).to eq 5
      end
    end

    context 'given a fresh user' do
      it 'should leave the user alone' do
        expect { fresh_user.update_if_required }.not_to change { fresh_user.full_name }
      end
    end
  end

  describe 'aggregation methods' do
    opts = [
      { count: 2,
        attributes: {
          created_at: DateTime.new(2015, 7, 10, 9) # Summer, morning
        }
      }, {
        count: 4,
        attributes: {
          created_at: DateTime.new(2015, 1, 10, 21) # Winter, evening
        }
      }
    ]
    results = {
      time_of_day: :night,
      season: :winter,
      favourite_colour: 'brown'
    }
    let(:user) { FactoryGirl.create(:user) }
    let(:images) do
      opts.map do |options|
        FactoryGirl.build_list(:image, options[:count], options[:attributes])
      end
    end

    before { user.images << images.flatten }
    %w(season time_of_day favourite_colour).each do |method|
      context "calling ##{method}" do
        let(:expected_result) { results[method.to_sym] }
        subject { user.send(method.to_sym) }
        it { is_expected.to eq expected_result }
      end
    end
  end
end
