require File.expand_path '../../../spec_helper', __FILE__

describe Rdb::BoardsController, type: :controller do
  fixtures :users

  let(:board) do
    RdbBoard.create! name: 'My Board', engine: Rdb::Taskboard
  end

  let(:boards) do
    [
      board,
      RdbBoard.create!(name: 'Another board', engine: Rdb::Taskboard)
    ]
  end

  before { request.accept = 'application/json' }
  let(:resp) { action; response }
  let(:json) { JSON.load(resp.body) }

  describe 'GET index' do
    before { boards }
    let(:action) { get :index }
    subject { resp }

    it { expect(subject.status).to eq 200 }

    describe 'JSON body' do
      subject { json }

      it { expect(subject.size).to eq 2 }
    end
  end

  describe 'GET show' do
    let(:action) { get :show, id: board.id }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 401 }
      it { expect(resp.body).to be_blank }
    end

    context 'as authorized principal' do
      let(:current_user) { User.find 2 }
      before { RdbBoardPermission.create! rdb_board: board, principal: current_user, role: RdbBoardPermission::ADMIN }

      it { expect(subject.status).to eq 200 }

      describe 'JSON body' do
        subject { json }

        it do
          is_expected.to eq \
            'id' => board.id,
            'name' => board.name,
            'type' => 'taskboard',
            'columns' => []
        end
      end
    end
  end

  describe 'PATCH update' do
    let(:params) { {} }
    let(:action) { patch :update, params.as_json.merge(id: board.id) }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 401 }
      it { expect(resp.body).to be_blank }
    end

    context 'as authorized principal' do
      let(:current_user) { User.find 2 }
      before { RdbBoardPermission.create! rdb_board: board, principal: current_user, role: RdbBoardPermission::ADMIN }

      describe '#name' do
        context 'empty' do
          let(:params) { {'name' => ''} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq 'errors' => {'name' => ["can't be blank"]} }
        end

        context 'already taken' do
          before { RdbBoard.create! name: 'Board name', engine: Rdb::Taskboard }
          let(:params) { {'name' => 'Board name'} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq 'errors' => {'name' => ["has already been taken"]} }
        end
      end
    end
  end
end
