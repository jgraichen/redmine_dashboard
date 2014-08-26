require File.expand_path '../../../spec_helper', __FILE__

describe Rdb::PermissionsController, type: :controller do
  fixtures :users

  let(:board) do
    RdbBoard.create! name: 'My Board', engine: Rdb::Taskboard
  end

  before { request.accept = 'application/json' }
  let(:resp) { action; response }
  let(:json) { JSON.load(resp.body).deep_symbolize_keys }

  let(:a_user) { User.find 2 }
  let(:another_user) { User.find 3 }

  let!(:permissions) do
    [
      RdbBoardPermission.create!(rdb_board: board, principal: a_user, role: RdbBoardPermission::ADMIN),
      RdbBoardPermission.create!(rdb_board: board, principal: another_user, role: RdbBoardPermission::EDIT)
    ]
  end

  let(:permission) { permissions[0] }

  describe 'GET index' do
    let(:action) { get :index, rdb_board_id: board.id }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 404 }
      it { expect(subject.body).to be_blank }
    end

    context 'as non-administrative user' do
      let(:current_user) { another_user }

      it { expect(subject.status).to eq 404 }
      it { expect(subject.body).to be_blank }
    end

    context 'as board administrator' do
      let(:current_user) { a_user }

      it { expect(subject.status).to eq 200 }

      describe 'JSON body' do
        subject { json }

        it { expect(subject.size).to eq 2 }
        it { expect(json[0]).to eq Rdb::PermissionDecorator.new(permissions[0]).as_json({}) }
      end
    end
  end

  describe 'GET show' do
    let(:action) { get :show, rdb_board_id: board.id, id: permission.id }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 404 }
      it { expect(resp.body).to be_blank }
    end

    context 'as non-administrative user' do
      let(:current_user) { another_user }

      it { expect(subject.status).to eq 404 }
      it { expect(subject.body).to be_blank }
    end

    context 'as authorized principal' do
      let(:current_user) { a_user }
      before { Setting.gravatar_enabled = 1 }

      it { expect(subject.status).to eq 200 }

      describe 'JSON body' do
        subject { json }

        it do
          is_expected.to eq \
            id: permission.id,
            type: 'user',
            name: current_user.name,
            role: 'ADMIN',
            avatar_url: 'https://secure.gravatar.com/avatar/8238a5d4cfa7147f05f31b63a8a320ce?rating=PG&size=128&default='
        end
      end
    end
  end

  describe 'PATCH update' do
    let(:params) { {} }
    let(:action) { patch :update, params.as_json.merge(rdb_board_id: board.id, id: permission.id) }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 404 }
      it { expect(resp.body).to be_blank }
    end

    context 'as authorized principal' do
      let(:current_user) { User.find 2 }

      describe '#role' do
        let(:permission) { permissions[1] }

        context 'invalid' do
          let(:params) { {'role' => 'MASTER_OF_DESASTER'} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq errors: {role: ['is not included in the list']} }
        end

        context 'valid' do
          let(:params) { {'role' => 'READ'} }

          it { expect(subject.status).to eq 200 }
          it { expect{ subject }.to change{ permission.reload.role }.to('read') }
        end

        context 'self permission' do
          let(:permission) { permissions[0] }
          let(:params) { {'role' => 'READ'} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq errors:['cannot edit own permission'] }
        end
      end
    end
  end
end
