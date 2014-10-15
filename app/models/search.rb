class Search

  def self.find(keyword)
    search_string = "%#{keyword.downcase}%"

    results = {}
    results[:users] = User.where('name LIKE ? or email LIKE ?', search_string, search_string)
    results[:equipment] = Equipment.where('name LIKE ? or description LIKE ?', search_string, search_string)
    results[:reservations] = Reservation.where('project LIKE ?', search_string)

    results
  end
end