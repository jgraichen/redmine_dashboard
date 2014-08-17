require File.expand_path '../../spec_helper', __FILE__

describe RdbBoard do
  fixtures :projects, :users

  let(:board) do
    RdbBoard.create \
      engine: Rdb::Taskboard,
      name: 'Test Board'
  end

  describe '@preferences' do
    let(:preferences) { {options: {columns: [:a, :b, :c]}} }
    it 'should store a hash' do
      board.preferences = preferences
      board.save

      expect(RdbBoard.find(board.id).preferences).to eq preferences
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
        RdbBoardPermission.create! rdb_board: board, principal: User.find(2),
          role: RdbBoardPermission::ADMIN
      end

      let(:principal) { User.find 2 }
      it { is_expected.to be true }
    end
  end
end
