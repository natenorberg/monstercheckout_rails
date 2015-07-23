class SearchController < ApplicationController
  before_filter :user_signed_in

  def index
    matches = find_exact_matches(params[:keyword])
    if !matches.nil? && matches.count == 1
      redirect_to(matches.first)
    else
      @search_term = params[:keyword]

      results = Search.find(params[:keyword])

      @users = results[:users] if current_user.is_admin?
      @reservations = results[:reservations] if current_user.monitor_access?
      @equipment = results[:equipment]
    end
  end

  private

    def find_exact_matches(keyword)
      if current_user.is_admin?
        matches = User.where(email: keyword) + User.where(name: keyword)
        if !matches.nil? && matches.count > 0
          return matches
        end
      end

      matches = Equipment.where(name: keyword)
      if !matches.nil? && matches.count > 0
        return matches
      end

      if current_user.monitor_access?
        matches = Reservation.where(project: keyword)
      else
        matches = Reservation.where(user: current_user, project: keyword)
        if !matches.nil? && matches.count > 0
          return matches
        end
      end
    end
end
