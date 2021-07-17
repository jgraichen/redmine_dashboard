# frozen_string_literal: true

require File.expand_path('../../spec_helper', __dir__)

describe RdbDashboard do
  fixtures :projects

  subject(:dashboard) { RdbDashboard.new(project, options, params) }

  let(:project) { Project.find(1) }
  let(:options) { {} }
  let(:params) { {} }

  describe '#projects' do
    subject(:projects) { dashboard.projects }

    it 'returns the project' do
      expect(projects.size).to eq 1
      expect(projects[0]).to eq project
    end

    context 'with subprojects included' do
      let(:options) { {include_subprojects: true} }

      it 'returns projects and subprojects' do
        expect(projects.map(&:id)).to eq [1, 3, 4, 5, 6]
      end
    end
  end

  describe '#project_ids' do
    subject(:project_ids) { dashboard.project_ids }

    it { is_expected.to eq [1] }

    context 'with subprojects included' do
      let(:options) { {include_subprojects: true} }

      it { is_expected.to eq [1, 3, 4, 5, 6] }
    end
  end
end
