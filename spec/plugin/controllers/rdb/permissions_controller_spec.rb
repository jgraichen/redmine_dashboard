require File.expand_path '../../../spec_helper', __FILE__

Roles = Rdb::Permission::Roles

describe Rdb::PermissionsController, type: :controller do
  fixtures :users, :email_addresses

  let(:board) { Rdb::Taskboard.create! name: 'My Board' }

  before { request.accept = 'application/json' }
  let(:resp) { action; response }
  let(:json) { JSON.load(resp.body).deep_symbolize_keys }

  let(:a_user) { User.find 2 }
  let(:another_user) { User.find 3 }

  let!(:permissions) do
    [
      Rdb::Permission.create!(dashboard: board, principal: a_user, role: Roles::ADMIN),
      Rdb::Permission.create!(dashboard: board, principal: another_user, role: Roles::EDIT)
    ]
  end

  let(:permission) { permissions[0] }

  describe 'GET index' do
    let(:action) { get :index, params: {rdb_board_id: board.id} }
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
        it { expect(json[0]).to eq permissions[0].as_json }
      end
    end
  end

  describe 'GET show' do
    let(:action) do
      get :show, params: {rdb_board_id: board.id, id: permission.id}
    end

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
          is_expected.to match \
            id: permission.id,
            role: 'ADMIN',
            principal: {
              id: current_user.id,
              name: current_user.name,
              type: 'user',
              value: current_user.login,
              avatar_url: a_string_matching(%r{gravatar.com/avatar/8238a5d4cfa7147f05f31b63a8a320ce})
            }
        end
      end
    end
  end

  describe 'GET search' do
    let(:q) { '' }
    let(:action) do
      get :search, params: {q: q, rdb_board_id: board.id}
    end
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

    context 'as authorized principal' do
      let(:current_user) { a_user }

      it { expect(subject.status).to eq 200 }
      it { expect(json.size).to eq 5 }
      it { expect(json.map{|r| r[:name]}).to match_array ['Redmine Admin', 'Robert Hill', 'Dave2 Lopper2', 'Some One', 'User Misc'] }

      it 'should not include users already having permission' do
        expect(json.map{|r| r[:id]}).to_not include 2
        expect(json.map{|r| r[:id]}).to_not include 3
      end

      context 'with query param' do
        let(:q) { 'lop' }

        it { expect(subject.status).to eq 200 }
        it { expect(json.size).to eq 1 }
        it { expect(json.map{|r| r[:name]}).to match_array ['Dave2 Lopper2'] }
      end
    end
  end

  describe 'POST create' do
    let(:params) { {} }
    let(:action) do
      post :create, params: {**params, rdb_board_id: board.id}
    end
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
      let(:params) { {principal: principal.login, role: Roles::READ} }

      it { expect(subject.status).to eq 200 }
      it { expect{ subject }.to change{ Rdb::Permission.count }.by(1) }

      it 'should create permission record' do
        subject
        perm = Rdb::Permission.last
        expect(perm.principal).to eq principal
        expect(perm.role).to eq Roles::READ
      end

      it 'should return JSON response' do
        expect(json).to eq Rdb::Permission.last.as_json
      end

      context 'duplicate' do
        before { Rdb::Permission.create! principal: principal, dashboard: board, role: Roles::EDIT }

        it { expect(subject.status).to eq 422 }
        it { expect(json).to eq errors: {principal_id: ['already_taken']} }
      end

      context 'with invalid principal' do
        let(:params) { {**super(), principal: 'abcderfgth'} }

        it { expect(subject.status).to eq 422 }
        it { expect(json).to eq errors: {principal_id: ['principal_not_found']} }
      end
    end
  end

  describe 'PATCH update' do
    let(:params) { {} }
    let(:action) do
      patch :update, params: {**params, rdb_board_id: board.id, id: permission.id}
    end
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
          let(:params) { {role: 'MASTER_OF_DESASTER'} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq errors: {role: ['invalid_role']} }
        end

        context 'valid' do
          let(:params) { {role: 'read'} }

          it { expect(subject.status).to eq 200 }
          it { expect{ subject }.to change{ permission.reload.role }.to('read') }
        end

        context 'self permission' do
          let(:permission) { permissions[0] }
          let(:params) { {role: 'read'} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq errors:['cannot_edit_own_permission'] }
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:action) do
      delete :destroy, params: {rdb_board_id: board.id, id: permission.id}
    end
    let(:permission) { permissions[1] }
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
      it { expect{ subject }.to change{ Rdb::Permission.where(id: permission.id).count }.from(1).to(0) }
    end

    context 'self permission' do
      let(:current_user) { User.find 2 }
      let(:permission) { permissions[0] }

      it { expect(subject.status).to eq 422 }
      it { expect(json).to eq errors: ['cannot_delete_own_permission'] }
    end
  end
end
