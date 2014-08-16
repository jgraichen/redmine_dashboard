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

    it { expect(subject.status).to eq 200 }

    describe 'JSON body' do
      subject { json }

      it { expect(subject['id']).to eq board.id }
      it { expect(subject['name']).to eq board.name }
      it { expect(subject['type']).to eq 'taskboard' }
    end
  end

  describe 'PUT update' do
    let(:action) { put :update, req.as_json.merge(id: board.id) }
    subject { resp }

    describe '#name' do
      context 'empty' do
        let(:req) { board.as_json.merge(name: '') }

        it { expect(subject.status).to eq 422 }
        it { expect(json).to eq 'errors' => {'name' => ["can't be blank"]} }
      end

      context 'already taken' do
        before { RdbBoard.create! name: 'Board name', engine: Rdb::Taskboard }
        let(:req) { board.as_json.merge(name: 'Board name') }

        it { expect(subject.status).to eq 422 }
        it { expect(json).to eq 'errors' => {'name' => ["has already been taken"]} }
      end
    end
  end
end
