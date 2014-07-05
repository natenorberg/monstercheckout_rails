class SessionsController < ApplicationController

  def new
    @disable_nav = true
  end

  private

    def session_params
      params.require(:session).permit(:email, :password)
    end

end
