require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without full name' do
    expect(FactoryGirl.build(:user, full_name: nil)).to be_invalid
  end

  describe '#update_if_required' do
    let(:user) { FactoryGirl.build(:user, updated_at: update_time) }

    context 'given a stale user' do
      let(:update_time) { 3.days.ago }

      it 'should update the user' do
        expect(user).to receive(:update_profile)
        user.update_if_required
      end
    end

    context 'given a fresh user' do
      let(:update_time) { Date.today }

      it 'should leave the user alone' do
        expect(user).to_not receive(:update_profile)
        user.update_if_required
      end
    end
  end
end
