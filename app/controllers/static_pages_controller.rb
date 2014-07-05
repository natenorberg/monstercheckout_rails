class StaticPagesController < ApplicationController
  def home
  end

  def welcome
    @disable_nav = true
  end
end
