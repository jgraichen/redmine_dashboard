require File.expand_path '../../../spec_helper', __FILE__

describe Rdb::BoardsController, type: :controller do
  fixtures :users, :issue_statuses, :email_addresses

  let(:board) { Rdb::Taskboard.create! name: 'My Board' }

  let(:boards) do
    [board, Rdb::Taskboard.create!(name: 'Another board')]
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
    let(:action) { get :show, params: {id: board.id} }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 404 }
      it { expect(resp.body).to be_blank }
    end

    context 'as authorized principal' do
      let(:current_user) { User.find 2 }
      let!(:permission) do
        Rdb::Permission.create! dashboard: board,
          principal: current_user, role: Rdb::Permission::ADMIN
      end
      before { Setting.gravatar_enabled = 1 }

      it { expect(subject.status).to eq 200 }

      describe 'JSON body' do
        subject { json }

        it { expect(subject['id']).to eq board.id }
        it { expect(subject['name']).to eq board.name }
        it { expect(subject['type']).to eq 'taskboard' }

        describe 'columns' do
          subject { json['columns'] }

          it { expect(subject.size).to eq 5 }
          it { expect(subject.map{|row| row['name']}).to match_array %w(New Assigned Resolved Feedback Done) }
        end

        describe 'permissions' do
          subject { json['permissions'] }

          it do
            is_expected.to match \
              [{
                'id' => permission.id,
                'role' => 'ADMIN',
                'principal' => {
                  'type' => 'user',
                  'id' => current_user.id,
                  'name' => current_user.name,
                  'value' => current_user.login,
                  'avatar_url' => a_string_matching(%r{gravatar.com/avatar/8238a5d4cfa7147f05f31b63a8a320ce})
                }
              }]
          end
        end
      end
    end
  end

  describe 'PATCH update' do
    let(:params) { {} }
    let(:action) { patch :update, params: {**params, id: board.id} }
    subject { resp }

    context 'as anonymous' do
      it { expect(subject.status).to eq 404 }
      it { expect(resp.body).to be_blank }
    end

    context 'as authorized principal' do
      let(:current_user) { User.find 2 }
      before { Rdb::Permission.create! dashboard: board, principal: current_user, role: Rdb::Permission::ADMIN }

      describe '#name' do
        context 'empty' do
          let(:params) { {name: ''} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq 'errors' => {'name' => ["required"]} }
        end

        context 'already taken' do
          before { Rdb::Taskboard.create! name: 'Board name' }
          let(:params) { {name: 'Board name'} }

          it { expect(subject.status).to eq 422 }
          it { expect(json).to eq 'errors' => {'name' => ["already_taken"]} }
        end
      end
    end
  end
end
