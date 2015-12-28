require 'rails_helper'

RSpec.describe UserStatisticsService do
  results = {
    time_of_day: :night,
    season: :winter,
    tags: {
      average: 2,
      max: 60,
      top_tags: [
        { tag: 'common_tag', count: 400 },
        { tag: 'another_common_tag', count: 200 },
        { tag: 'another_uncommon_tag', count: 40 },
        { tag: 'uncommon_tag', count: 20 }
      ]
    }
  }

  opts = [
    {
      count: 10,
      attributes: [:winter_evening, :lots_of_tags]
    },
    {
      count: 5,
      attributes: [:summer_morning, :not_many_tags]
    }
  ]

  let(:user) { FactoryGirl.create(:user) }
  let(:empty_user) { FactoryGirl.create(:user) }
  let(:images) do
    opts.map do |options|
      FactoryGirl.build_list(:image, options[:count], *options[:attributes] << :processed)
    end
  end

  def create_service(user)
    UserStatisticsService.new(user)
  end

  before do
    user.images << images.flatten
  end

  %i(season time_of_day tags).each do |method|
    describe "##{method}" do
      context 'given a user with images' do
        let(:service) { create_service(user) }
        subject { service.send(method) }

        it { is_expected.to eq results[method] }
      end

      context 'given a user with no images' do
        let(:service) { create_service(empty_user) }
        subject { service.send(method) }

        it { is_expected.to be_nil }
      end
    end
  end

  describe '#favourite_colour' do
    context 'given a user with images' do
      let(:service) { create_service(user) }
      subject(:fav) { service.favourite_colour }

      it 'returns a named colour' do
        expect(Sinebow.primary_colours).to include fav
      end
    end

    context 'given a user with no images' do
      let(:service) { create_service(empty_user) }
      subject(:fav) { service.favourite_colour }

      it { is_expected.to be_nil }
    end
  end

  describe '#colours' do
    context 'given a user with images' do
      let(:service) { create_service(user) }
      subject(:colours) { service.colours }

      it 'returns the correct hash' do
        expect(colours).to all include(colour: be_a_kind_of(String), count: a_value >= 0)
        expect(colours.length).to be 50
      end
    end

    context 'given a user with no images' do
      let(:service) { create_service(empty_user) }
      subject { service.colours }

      it { is_expected.to be_nil }
    end
  end
end
