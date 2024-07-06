class SuperAdmins::SessionsController < Devise::SessionsController
  include RemoteUserConcern

  before_action :authenticate_from_remote_user
  before_action :authenticate_super_admin
end
