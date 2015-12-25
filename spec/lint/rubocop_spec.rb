require 'rails_helper'

describe 'Rubocop' do
  let!(:files) do
    current_sha = `git rev-parse --verify HEAD`.strip!
    files = `git diff #{current_sha} --name-only`
    files.split("\n").select do |f|
      /.*\.rb$/.match(f).present?
    end.join(' ')
  end

  context 'given the files that have changed' do
    subject(:report) { `rubocop #{files}` }
    it 'checks that there are no syntax offenses' do
      expect(report.match('Offenses')).to be_nil
    end
  end
end
