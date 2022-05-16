class GeotagWorker
  include Sidekiq::Worker
  sidekiq_options  :retry => true, :backtrace => true #, expires_in: 1.day
  def perform(id)
    record = PhoneLead.find(id)
    identifier = Phonelib.parse (record.number)

    begin
      state = Integer(record.area_code).to_region
      if state
        record.location = state
      end
    rescue
      # Ignore
    end

    if identifier
      record.number_type = identifier.human_type
      record.country = identifier.country
      record.state ||= identifier.geo_name
    end

    record.save

  end

end

