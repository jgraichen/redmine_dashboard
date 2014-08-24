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
      it { expect(subject.status).to eq 404 }
      it { expect(resp.body).to be_blank }
    end

    context 'as authorized principal' do
      let(:current_user) { User.find 2 }
      let!(:permission) do
        RdbBoardPermission.create! rdb_board: board,
          principal: current_user, role: RdbBoardPermission::ADMIN
      end
      before { Setting.gravatar_enabled = 1 }

      it { expect(subject.status).to eq 200 }

      describe 'JSON body' do
        subject { json }

        it do
          is_expected.to eq \
            'id' => board.id,
            'name' => board.name,
            'type' => 'taskboard',
            'columns' => [],
            'permissions' => [
              {
                'id' => permission.id,
                'type' => 'user',
                'name' => current_user.name,
                'role' => 'ADMIN',
                'avatar_url' => 'https://secure.gravatar.com/avatar/8238a5d4cfa7147f05f31b63a8a320ce?rating=PG&size=128&default='
              }
            ]
        end
      end
    end
  end

  describe 'PATCH update' do
    let(:params) { {} }
    let(:action) { patch :update, params.as_json.merge(id: board.id) }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 404 }
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
