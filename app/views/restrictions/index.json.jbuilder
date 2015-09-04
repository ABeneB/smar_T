json.array!(@restrictions) do |restriction|
  json.extract! restriction, :id, :company_id, :user_id, :problem, :dynamic, :multi_vehicle, :time_window, :capacity_restriction, :priorities, :work_time
  json.url restriction_url(restriction, format: :json)
end
