class SessionsController < ApplicationController

  def new
    @disable_nav = true
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to home_path
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

    def session_params
      params.require(:session).permit(:email, :password)
    end

end
