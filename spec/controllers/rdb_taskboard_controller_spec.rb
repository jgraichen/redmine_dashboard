# frozen_string_literal: true

require 'spec_helper'

describe RdbTaskboardController, type: :controller do
  fixtures %i[
    enabled_modules
    issues
    member_roles
    members
    projects
    roles
    users
    versions
    workflows
  ]

  let(:project) { Project.find 'ecookbook' }
  let(:user) { User.find_by!(login: 'jsmith') }
  let(:issue) { Issue.find(1) }

  before do
    set_permissions
    project.enable_module! :dashboard
    request.session[:user_id] = user.id
  end

  describe '#move' do
    context 'without column' do
      it 'responds with a flash message' do
        post :move, params: {id: project, issue: issue, lock_version: issue.lock_version}

        expect(response).to have_http_status(:ok)
        expect(flash.now[:rdb_error]).to match(/Invalid request/)
      end
    end
  end
end
