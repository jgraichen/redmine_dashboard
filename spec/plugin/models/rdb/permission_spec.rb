require File.expand_path '../../../spec_helper', __FILE__

describe Rdb::Permission do
  fixtures :projects, :users, :email_addresses

  let(:board) { Rdb::Taskboard.create! name: 'Test Board' }
  let(:permission) { Rdb::Permission.create! dashboard: board, principal: principal, role: role }

  describe '#read?' do
    subject { permission.read? requester }

    context 'with user principal' do
      let(:principal) { User.find 2 }

      context 'with ADMIN role' do
        let(:role) { Rdb::Permission::ADMIN }

        context 'as active principal' do
          let(:requester) { User.find 2 }
          it { is_expected.to eq true }
        end

        context 'as locked principal' do
          before { principal.lock! }

          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as registered principal' do
          before { principal.register! }

          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as another user' do
          let(:requester) { User.find 3 }
          it { is_expected.to eq false }
        end
      end

      context 'with READ role' do
        let(:role) { Rdb::Permission::READ }

        context 'as active principal' do
          let(:requester) { User.find 2 }
          it { is_expected.to eq true }
        end

        context 'as locked principal' do
          before { principal.lock! }

          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as registered principal' do
          before { principal.register! }

          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as another user' do
          let(:requester) { User.find 3 }
          it { is_expected.to eq false }
        end
      end
    end

    context 'with group principal' do
      let(:principal) { Group.create! name: 'Group' }
      before { principal.users << User.find(2) }

      context 'with ADMIN role' do
        let(:role) { Rdb::Permission::ADMIN }

        context 'as active group member' do
          let(:requester) { User.find 2 }
          it { is_expected.to eq true }
        end

        context 'as another user' do
          let(:requester) { User.find 3 }
          it { is_expected.to eq false }
        end
      end

      context 'with READ role' do
        let(:role) { Rdb::Permission::READ }

        context 'as active group member' do
          let(:requester) { User.find 2 }
          it { is_expected.to eq true }
        end

        context 'as another user' do
          let(:requester) { User.find 3 }
          it { is_expected.to eq false }
        end
      end
    end
  end

  describe '#write?' do
    subject { permission.write? requester }

    context 'with user principal' do
      let(:principal) { User.find 2 }

      context 'with ADMIN role' do
        let(:role) { Rdb::Permission::ADMIN }

        context 'as active principal' do
          let(:requester) { User.find 2 }
          it { is_expected.to eq true }
        end

        context 'as locked principal' do
          before { principal.lock! }

          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as registered principal' do
          before { principal.register! }

          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as another user' do
          let(:requester) { User.find 3 }
          it { is_expected.to eq false }
        end
      end

      context 'with READ role' do
        let(:role) { Rdb::Permission::READ }

        context 'as active principal' do
          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as locked principal' do
          before { principal.lock! }

          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as registered principal' do
          before { principal.register! }

          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as another user' do
          let(:requester) { User.find 3 }
          it { is_expected.to eq false }
        end
      end
    end

    context 'with group principal' do
      let(:principal) { Group.create! name: 'Group' }
      before { principal.users << User.find(2) }

      context 'with ADMIN role' do
        let(:role) { Rdb::Permission::ADMIN }

        context 'as active group member' do
          let(:requester) { User.find 2 }
          it { is_expected.to eq true }
        end

        context 'as another user' do
          let(:requester) { User.find 3 }
          it { is_expected.to eq false }
        end
      end

      context 'with READ role' do
        let(:role) { Rdb::Permission::READ }

        context 'as active group member' do
          let(:requester) { User.find 2 }
          it { is_expected.to eq false }
        end

        context 'as another user' do
          let(:requester) { User.find 3 }
          it { is_expected.to eq false }
        end
      end
    end
  end
end
