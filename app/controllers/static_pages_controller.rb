class StaticPagesController < ApplicationController
  def home
    if !signed_in?
      redirect_to welcome_path
    end
  end

  def welcome
    @disable_nav = true
  end

  def about
  end

  def help
  end

  # Release notes
  def v1_1
  end

  def v1_2
  end
end
