class SearchController < ApplicationController
  before_filter :user_signed_in

  def index
    # TODO: Deal with more than one exact matches
    if match = find_exact_match(params[:keyword])
      redirect_to(match)
    else
      @search_term = params[:keyword]

      results = Search.find(params[:keyword])
      
      @users = results[:users]
      @equipment = results[:equipment]
      @reservations = results[:reservations]
    end
  end

  private

    def find_exact_match(keyword)
      User.find_by(name: keyword) || User.find_by(email: keyword) ||
        Equipment.find_by(name: keyword) ||
        Reservation.find_by(project: keyword)
    end

end
