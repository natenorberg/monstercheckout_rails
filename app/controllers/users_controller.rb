class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :password, :update, :destroy]
  before_filter :user_signed_in
  before_filter :user_is_admin, only: [:index, :new, :create, :destroy]
  before_filter :current_user_or_admin, only: [:show, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/monitors
  def monitors
    @users = User.where(is_monitor: true)
    render :index
  end

  # GET /users/admins
  def admins
    @users = User.where(is_admin: true)
    render :index
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # GET /users/1/password
  def password
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        send_welcome_email
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        if params[:user][:password]
          format.html { render :password }
        end
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def send_welcome_email
      UserMailer.welcome_email(@user).deliver
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :is_admin, :is_monitor, 
                                   :notify_on_approval_needed, 
                                   :notify_on_approved, 
                                   :notify_on_denied, 
                                   :notify_on_checked_out, 
                                   :notify_on_checked_in, 
                                   permission_ids: [])
    end
end
