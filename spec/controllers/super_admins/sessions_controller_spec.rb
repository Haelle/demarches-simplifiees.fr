require 'rails_helper'

describe SuperAdmins::SessionsController, type: :controller do
  subject { @controller.send(:authenticate_super_admin) }

  let(:super_admin) { create(:super_admin) }
  let(:remote_user_email) { 'dummy@exemple.fr' }

  before do
    request.headers['X-Remote-User'] = remote_user_email
    request.headers['X-Remote-User-Group'] = remote_user_group
    @controller.send(:authenticate_from_remote_user)
    subject
  end

  context 'when user is SuperAdmin' do
    let(:remote_user_group) { 'BAP' }

    it { expect(@controller.super_admin_signed_in?).to eq(true) }
    it { expect(@controller.current_user.email).to eq(remote_user_email) }
  end

  context 'when user is not SuperAdmin' do
    let(:remote_user_group) { 'NOT_BAP' }

    it { expect(@controller.super_admin_signed_in?).to eq(false) }
    it { expect(@controller.current_user.email).to eq(remote_user_email) }
  end
end
