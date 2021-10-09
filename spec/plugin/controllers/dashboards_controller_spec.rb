# frozen_string_literal: true

require_relative '../spec_helper'

describe RdbDashboardsController, type: :controller do
  describe 'GET index' do
    let(:action) { get :index }
    subject { action; response }

    it { expect(subject.status).to eq 200 }
  end
end
