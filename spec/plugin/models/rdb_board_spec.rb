require 'spec_helper'

describe RdbBoard do
  fixtures :projects

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

  describe '#as_json' do
    subject { board.as_json }

    it { expect(subject.keys).to eq [:id, :name, :engine] }
    it { expect(subject[:id]).to eq board.id }
    it { expect(subject[:name]).to eq board.name }
  end
end
