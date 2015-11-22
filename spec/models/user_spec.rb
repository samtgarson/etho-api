require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without full name' do
    expect(FactoryGirl.build(:user, full_name: nil)).to be_invalid
  end

  before(:each) do
    allow_any_instance_of(Insta).to receive(:profile).and_return(FactoryGirl.build(:user, _id: 123456))
  end

  describe '#update_if_required' do
    let!(:stale_user) { FactoryGirl.create(:user, updated_at: 3.days.ago, _id: 123456) }
    let!(:fresh_user) { FactoryGirl.create(:user, updated_at: Time.now) }

    context 'given a stale user' do
      it 'should update the user' do
        expect { stale_user.update_if_required }.to change { stale_user.full_name }
      end
    end

    context 'given a fresh user' do
      it 'should leave the user alone' do
        expect { fresh_user.update_if_required }.not_to change { fresh_user.full_name }
      end
    end
  end
end
