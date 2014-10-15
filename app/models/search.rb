class Search

  def self.find(keyword)
    search_string = "%#{keyword.downcase}%"

    results = {}
    results[:users] = User.where('name LIKE ?', search_string) + User.where('email LIKE ?', search_string)
    results[:equipment] = Equipment.where('name LIKE ?', search_string) + Equipment.where('description LIKE ?', search_string)
    results[:reservations] = Reservation.where('project LIKE ?', search_string)

    results
  end
end