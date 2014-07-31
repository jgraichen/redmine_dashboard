require 'spec_helper'

describe Rdb::BoardsController, type: :controller do
  let(:board) do
    RdbBoard.create! name: 'My Board', engine: Rdb::Taskboard
  end

  describe 'GET show' do
    subject { get :show, id: board.id, format: 'json' }

    it { expect(subject.status).to eq 200 }

    describe 'JSON body' do
      subject { JSON.load(super().body).symbolize_keys }

      it { should eq id: board.id, name: 'My Board' }
    end
  end
end
