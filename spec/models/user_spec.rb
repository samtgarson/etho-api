require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without username' do
    expect(FactoryGirl.build(:user, username: nil)).to be_invalid
  end

  before do
    allow(Insta).to receive_messages(
      profile: FactoryGirl.build(:user, _id: '123456'),
      user_images: FactoryGirl.build_list(:image, 5, user_id: '123456'))
  end

  describe '#update_if_required' do
    RSpec::Matchers.define_negated_matcher :leave_unchanged, :change

    let!(:stale_user) { FactoryGirl.create(:user, processed: true, updated_at: 3.days.ago, _id: '123456') }
    let!(:fresh_user) { FactoryGirl.create(:user, processed: true, updated_at: Time.now) }

    context 'given a stale user' do
      it 'should update the user' do
        expect { stale_user.update_if_required }.to change { stale_user.full_name }
          .and change { stale_user.images.count }.by 5
      end
    end

    context 'given a fresh user' do
      it 'should leave the user alone' do
        expect { fresh_user.update_if_required }.to leave_unchanged { fresh_user.full_name }
          .and leave_unchanged { fresh_user.images.count }
      end
    end
  end
end
