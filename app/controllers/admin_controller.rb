class AdminController < ApplicationController
  before_filter :user_signed_in
  before_filter :user_is_admin

  def dashboard
    @users = User.all
    @permissions = Permission.all
  end
end
