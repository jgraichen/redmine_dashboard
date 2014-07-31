require 'spec_helper'

describe Rdb::BoardsController, type: :controller do
  let(:board) do
    RdbBoard.create! name: 'My Board', engine: Rdb::Taskboard
  end

  describe 'GET show' do
    subject { get :show, id: board.id, format: 'json' }

    it { expect(subject.status).to eq 200 }

    describe 'JSON body' do
      subject { JSON.load super().body }

      it { expect(subject.keys).to eq %w(id name engine) }
      it { expect(subject['id']).to eq board.id }
      it { expect(subject['name']).to eq board.name }
    end
  end
end
