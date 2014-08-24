require File.expand_path '../../../spec_helper', __FILE__

describe Rdb::IssuesController, type: :controller do
  fixtures :users

  let(:board) do
    RdbBoard.create! name: 'My Board', engine: Rdb::Taskboard
  end

  before { request.accept = 'application/json' }
  let(:resp) { action; response }
  let(:json) { JSON.load(resp.body) }

  describe 'GET index' do
    let(:action) { get :index, rdb_board_id: board.id }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 404 }
      it { expect(resp.body).to be_blank }
    end

    context 'as authorized principal' do
      let(:current_user) { User.find 2 }
      before { RdbBoardPermission.create! rdb_board: board, principal: current_user, role: RdbBoardPermission::READ }

      it { expect(subject.status).to eq 200 }
    end
  end
end
