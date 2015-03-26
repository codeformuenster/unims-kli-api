require "open-uri"
require "csv"
require "json"

class KliAPI
  def self.call(env)
    [200, {"Content-Type"=>"application/json; charset=utf-8", "Access-Control-Allow-Origin"=>"*"}, [self.get_kli]]
  end


  CACHE_MAX_AGE = 120
  @url = "http://www.uni-muenster.de/Klima/data/CR3000_Data24h.dat"
  @headers = [:TIMESTAMP, :RECORD, :AirTC_Avg, :SW_in_Avg, :WS_ms_S_WVT, :WindDir_D1_WVT, :WindDir_SD1_WVT, :WS_Gust_Max, :RH_Avg, :BP_kPa_Avg, :Rain_Tot, :BiralVisInst_Avg, :WeatherCode00_Tot, :WeatherCode04_Tot, :WeatherCode30_Tot, :WeatherCode40_Tot, :WeatherCode50_Tot, :WeatherCode60_Tot, :WeatherCode70_Tot]
  @cache = {
    fetch_time: Time.now
  }
  

  def self.get_kli
    if @cache[:fetch_time] != nil and Time.now - @cache[:fetch_time] < CACHE_MAX_AGE
      @cache[:kli]
    else
      self.build_cache
    end 
  end


  def self.build_cache
    csv = CSV.new(open(@url).read, { converters: [:numeric, :date_time], headers: @headers }).read
    fetch_time = Time.now

    data = csv[-1].to_h
    data[:fetch_time] = fetch_time
    @cache[:kli] = data.to_json
    @cache[:fetch_time] = fetch_time
    @cache[:kli]
  end

  self.build_cache

end







