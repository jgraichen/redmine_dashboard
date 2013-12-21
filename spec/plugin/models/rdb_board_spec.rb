require 'spec_helper'

describe RdbBoard do
  fixtures :projects

  let(:board) do
    RdbBoard.create :context => Project.find(1),
      :engine => Rdb::Taskboard, :name => 'Test Board'
  end

  describe '@preferences' do
    let(:preferences) { {:options => {:columns => [:a, :b, :c]}} }
    it 'should store a hash' do
      board.preferences = preferences
      board.save

      expect(RdbBoard.find(board.id).preferences).to eq preferences
    end
  end
end
