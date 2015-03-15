require File.expand_path '../../../spec_helper', __FILE__

describe Rdb::Dashboard do
  fixtures :projects, :users, :email_addresses

  let(:board) { Rdb::Taskboard.create name: 'Test Board' }

  describe '@preferences' do
    let(:preferences) { {options: {columns: [:a, :b, :c]}} }
    it 'should store a hash' do
      board.preferences = preferences
      board.save

      expect(Rdb::Dashboard.find(board.id).preferences).to eq preferences
    end
  end

  describe '#name' do
    context 'uniqueness' do
      before { board }

      it { expect(Rdb::Taskboard.new(name: 'Test Board')).to_not be_valid }
      it { expect(Rdb::Taskboard.new(name: 'Test Board  ')).to_not be_valid }
      it { expect(Rdb::Taskboard.new(name: 'Test   Board')).to_not be_valid }
      it { expect(Rdb::Taskboard.new(name: ' Test  Board')).to_not be_valid }

      it { expect(Rdb::Taskboard.new(name: 'Test Board 2')).to be_valid }
    end
  end

  describe '#readable_for?' do
    subject { board.readable_for?(principal) }

    context 'as redmine administrator' do
      let(:principal) { User.find 1 }
      it { is_expected.to be true }
    end

    context 'as board administrator' do
      before do
        Rdb::Permission.create! dashboard: board, principal: User.find(2),
          role: Rdb::Permission::ADMIN
      end

      let(:principal) { User.find 2 }
      it { is_expected.to be true }
    end
  end
end
