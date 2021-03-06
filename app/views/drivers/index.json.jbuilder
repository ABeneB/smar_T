json.array!(@drivers) do |driver|
  json.extract! driver, :id, :user_id, :work_start_time, :work_end_time, :active, :working_time
  json.url driver_url(driver, format: :json)
end
