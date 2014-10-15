class SearchController < ApplicationController
  before_filter :user_signed_in

  def index
    # TODO: Deal with more than one exact matches
    if match = find_exact_match(params[:keyword])
      redirect_to(match)
    else
      @search_term = params[:keyword]

      results = Search.find(params[:keyword])

      @users = results[:users] if current_user.is_admin?
      @reservations = results[:reservations] if current_user.monitor_access?
      @equipment = results[:equipment]
    end
  end

  private

    def find_exact_match(keyword)
      if current_user.is_admin?
        match = User.find_by(name: keyword) || User.find_by(email: keyword)
        if !match.nil?
          return match
        end
      end

      match = Equipment.find_by(name: keyword)
      if !match.nil?
        return match
      end

      if current_user.monitor_access?
        match = Reservation.find_by(project: keyword)
        if !match.nil?
          return match
        end
      end
    end
end
