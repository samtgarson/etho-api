require 'rails_helper'

RSpec.describe UserStatisticsService do
  matched_colours = %w(01cdb1 dc9d05 fb5d26 ff4040)
  results = {
    time_of_day: :night,
    season: :winter,
    favourite_colour: 'brown',
    tags: {
      average: 2,
      max: 60,
      top_tags: [
        { tag: 'uncommon_tag', count: 20 },
        { tag: 'another_uncommon_tag', count: 40 },
        { tag: 'another_common_tag', count: 200 },
        { tag: 'common_tag', count: 400 }
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
  total_images = opts.inject(0) { |a, e| a + e[:count] }

  let(:user) { FactoryGirl.create(:user) }
  let(:empty_user) { FactoryGirl.create(:user) }
  let(:images) do
    opts.map do |options|
      FactoryGirl.build_list(:image, options[:count], *options[:attributes])
    end
  end

  def create_service(user)
    UserStatisticsService.new(user)
  end

  before do
    user.images << images.flatten
  end

  %i(season time_of_day favourite_colour tags).each do |method|
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

  describe '#colours' do
    let(:irrelevant_colours) do
      colours.reject { |h| matched_colours.include? h[:colour] }
    end
    let(:relevant_colours) do
      colours.reject { |h| matched_colours.exclude? h[:colour] }
    end

    context 'given a user with images' do
      let(:service) { create_service(user) }
      subject(:colours) { service.colours }

      it 'only has the right colours counted' do
        expect(irrelevant_colours).to all include count: 0
        expect(relevant_colours).to all include count: total_images
      end
    end

    context 'given a user with no images' do
      let(:service) { create_service(empty_user) }
      subject { service.colours }

      it { is_expected.to be_nil }
    end
  end
end
