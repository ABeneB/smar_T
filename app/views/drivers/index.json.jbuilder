json.array!(@drivers) do |driver|
  json.extract! driver, :id, :user_id, :company_id, :work_start_time, :work_end_time, :activ, :working_time
  json.url driver_url(driver, format: :json)
end
