require "open-uri"
require "csv"
require "json"

class KliAPI24h
  def self.call(env)
    [200, {"Content-Type"=>"application/json; charset=utf-8", "Access-Control-Allow-Origin"=>"*"}, [self.route(env)]]
  end

  def self.route(env)
    request_path = env["REQUEST_PATH"]
    kli_data = self.get_kli

    case request_path
    when /latest/
      { fetch_time: kli_data[:fetch_time], result: [kli_data[:result][-1]] }.to_json
    else
      kli_data.to_json
    end
  end

  CACHE_MAX_AGE = 120
  @url = "http://www.uni-muenster.de/Klima/data/CR3000_Data24h.dat"
  @headers = [:TIMESTAMP, :RECORD, :AirTC_Avg, :SW_in_Avg, :WS_ms_S_WVT, :WindDir_D1_WVT, :WindDir_SD1_WVT, :WS_Gust_Max, :RH_Avg, :BP_kPa_Avg, :Rain_Tot, :BiralVisInst_Avg, :WeatherCode00_Tot, :WeatherCode04_Tot, :WeatherCode30_Tot, :WeatherCode40_Tot, :WeatherCode50_Tot, :WeatherCode60_Tot, :WeatherCode70_Tot]
  @cache = {
    fetch_time: Time.now.utc.to_i
  }


  def self.get_kli
    if @cache[:fetch_time] != nil and Time.now.utc.to_i - @cache[:fetch_time] < CACHE_MAX_AGE
      @cache[:kli]
    else
      self.build_cache
    end
  end


  def self.build_cache
    csv = CSV.new(open(@url).read, { converters: [:numeric, :date_time], headers: @headers }).read
    fetch_time = Time.now.utc.to_i

    4.times { |i| csv.delete(0) }
    data = { fetch_time: fetch_time }
    data[:result] = csv.map do |row|
      temp_row = row.to_h

      time_a = temp_row[:TIMESTAMP].to_time.utc.to_a[0..5].reverse!
      time_a[6] = "+1"

      temp_row[:TIMESTAMP] = DateTime.new(*time_a)
      temp_row[:TIMESTAMP_UTC] = temp_row[:TIMESTAMP].to_time.utc.to_i

      temp_row
    end

    # strip properties
    if ENV["KLI_PROPERTIES"]
      wanted_props = ENV["KLI_PROPERTIES"].split(",").map(&:to_sym)

      data[:result].each do |res|
        res.keep_if { |k,v| wanted_props.include?(k) }
      end
    end

    @cache[:kli] = data
    @cache[:fetch_time] = fetch_time
    @cache[:kli]
  end

  self.build_cache

end

