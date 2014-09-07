require File.expand_path '../../../spec_helper', __FILE__

Roles = RdbBoardPermission::Roles

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
      RdbBoardPermission.create!(rdb_board: board, principal: a_user, role: Roles::ADMIN),
      RdbBoardPermission.create!(rdb_board: board, principal: another_user, role: Roles::EDIT)
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
            role: 'ADMIN',
            principal: {
              type: 'user',
              name: current_user.name,
              id: current_user.id,
              avatar_url: 'https://secure.gravatar.com/avatar/8238a5d4cfa7147f05f31b63a8a320ce?rating=PG&size=128&default='
            }
        end
      end
    end
  end

  describe 'POST create' do
    let(:params) { {} }
    let(:action) { post :create, params.as_json.merge(rdb_board_id: board.id) }
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
      let(:principal) { User.find 1 }
      let(:params) { {principal: {type: 'user', id: principal.id}, role: Roles::READ} }

      it { expect(subject.status).to eq 200 }
      it { expect{ subject }.to change{ RdbBoardPermission.count }.by(1) }

      it 'should create permission record' do
        subject
        perm = RdbBoardPermission.last
        expect(perm.principal).to eq principal
        expect(perm.role).to eq Roles::READ
      end

      it 'should return JSON response' do
        expect(json).to eq Rdb::PermissionDecorator.new(RdbBoardPermission.last).as_json({})
      end

      context 'duplicate' do
        before { RdbBoardPermission.create! principal: principal, rdb_board: board, role: Roles::EDIT }

        it { expect(subject.status).to eq 422 }
        it { expect(json).to eq errors: {principal_id: ['has already been taken']} }
      end

      context 'with invalid principal' do
        let(:params) { super().merge principal: {type: 'project', id: '57664'} }

        it { expect(subject.status).to eq 422 }
        it { expect(json).to eq errors: {principal_id: ["can't be blank"]} }
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

    context 'as non-administrative user' do
      let(:current_user) { another_user }

      it { expect(subject.status).to eq 404 }
      it { expect(subject.body).to be_blank }
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
          let(:params) { {'role' => 'read'} }

          it { expect(subject.status).to eq 200 }
          it { expect{ subject }.to change{ permission.reload.role }.to('read') }
        end

        context 'self permission' do
          let(:permission) { permissions[0] }
          let(:params) { {'role' => 'read'} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq errors:['cannot edit own permission'] }
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:action) { delete :destroy, rdb_board_id: board.id, id: permission.id }
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
      let(:current_user) { User.find 2 }

      it { expect(subject.status).to eq 204 }
      it { expect{ subject }.to change{ RdbBoardPermission.where(id: permission.id).count }.from(1).to(0) }
    end
  end
end
