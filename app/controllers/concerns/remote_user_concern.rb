module RemoteUserConcern
  extend ActiveSupport::Concern

  DEFAULT_PASSWORD = 'This is a very complicated password 2024 !'
  REMOTE_ADMIN_GROUP = ENV['AD_SUPER_ADMIN_GROUP']

  def authenticate_from_remote_user
    @remote_user = request.headers["X-Remote-User"]
    @remote_user_group = request.headers["X-Remote-User-Group"]
    log_remote_user_headers_info

    if request.headers["X-Remote-User"].present?
      user = User.find_by email: @remote_user

      if user
        handle_user_switch_between_requests(user)
        handle_user_group_change
        sign_in(user) unless user_signed_in?
      else
        user = create_user_from_headers
        sign_in user
      end
    else
      render json: { error: "No Remote User Header Found" }, status: 500
    end
  end

  private

  def handle_user_switch_between_requests(user)
    # not tested behaviour it's for dev purpose to easly switch profile
    if current_user && current_user != user
      sign_out current_user
      redirect_to root_path
    end
  end

  def log_remote_user_headers_info
    logger.info "Remote User: #{@remote_user} - #{@remote_user_group || 'No Group found'} (Current user: #{current_user&.email || 'no user yet'})"
  end

  def create_user_from_headers
    if @remote_user_group == REMOTE_ADMIN_GROUP
      create_admin_user_from_headers
    else
      create_normal_user_from_headers
    end
  end

  def create_admin_user_from_headers
    create_super_admin
    user = create_normal_user_from_headers
    user.create_instructeur!
    user.create_administrateur!
    return user
  end

  def create_normal_user_from_headers
    User.create!(
      email: @remote_user,
      password: DEFAULT_PASSWORD,
      confirmed_at: Time.zone.now,
      email_verified_at: Time.zone.now
    )
  end

  def user_is_newly_admin?
    @remote_user_group == REMOTE_ADMIN_GROUP && SuperAdmin.find_by(email: @remote_user).nil?
  end

  def user_is_not_admin_anymore?
    @remote_user_group != REMOTE_ADMIN_GROUP && SuperAdmin.find_by(email: @remote_user)
  end

  def remove_admin_rights
    SuperAdmin.find_by(email: @remote_user)&.delete
    user = User.find_by email: @remote_user
    user.instructeur&.delete
    user.administrateur&.delete
  end

  def handle_user_group_change
    if user_is_newly_admin?
      create_super_admin
      user = User.find_by email: @remote_user
      user.create_instructeur!
      user.create_administrateur!
    elsif user_is_not_admin_anymore?
      remove_admin_rights
    end
  end

  def create_super_admin
    SuperAdmin.create!(email: @remote_user, password: DEFAULT_PASSWORD)
  end
end
