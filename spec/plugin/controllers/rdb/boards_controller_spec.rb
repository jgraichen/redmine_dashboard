require File.expand_path '../../../spec_helper', __FILE__

describe Rdb::BoardsController, type: :controller do
  let(:board) do
    RdbBoard.create! name: 'My Board', engine: Rdb::Taskboard
  end

  let(:boards) do
    [
      board,
      RdbBoard.create!(name: 'Another board', engine: Rdb::Taskboard)
    ]
  end

  describe 'GET index' do
    before { boards }
    subject { get :index, format: 'json' }

    it { expect(subject.status).to eq 200 }

    describe 'JSON body' do
      subject { JSON.load super().body }

      it { expect(subject.size).to eq 2 }
    end
  end

  describe 'GET show' do
    subject { get :show, id: board.id, format: 'json' }

    it { expect(subject.status).to eq 200 }

    describe 'JSON body' do
      subject { JSON.load super().body }

      it { expect(subject['id']).to eq board.id }
      it { expect(subject['name']).to eq board.name }
      it { expect(subject['type']).to eq 'taskboard' }
    end
  end
end
