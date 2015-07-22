json.array!(@all_reservations) do |reservation|
  json.extract! reservation, :id, :project, :in_time, :out_time, :checked_out_time, :checked_in_time, :is_approved, :check_out_comments, :check_in_comments
  json.url reservation_url(reservation, format: :json)
end
