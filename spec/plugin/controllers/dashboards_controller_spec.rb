# frozen_string_literal: true

require_relative '../spec_helper'

describe RdbDashboardsController, type: :controller do
  fixtures %i[
    member_roles
    members
    projects
    roles
    users
  ]

  let(:project) { Project.find('ecookbook') }
  let(:user) { User.find(1) }

  before do
    set_permissions

    project.enable_module! 'issue_tracking'
    project.enable_module! 'dashboard'
    project.save!
  end

  describe 'GET index' do
    subject do
      get :index, params: {id: project}, session: {user_id: user.id}
    end

    it 'creates a new dashboard and redirects to it' do
      expect { subject }.to change(Rdb::Dashboard, :count).from(0).to(1)
      expect(response.status).to redirect_to rdb_dashboard_path(project, 1)
    end
  end
end
