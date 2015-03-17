require "nokogiri"
require "open-uri"
require "json"
require "pry"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

def create_hash(cols)
  hash = {
    name: cols[0].gsub(/[[:space:]]/, ' ').strip, # remove &nbsp;s
    value: cols[-1]
  }
  hash[:description] = cols[1] if cols.length > 2
  hash
end

## fetch stuff!
url = "http://www.uni-muenster.de/Klima/wetter/wetter.php"

data = {}

doc = Nokogiri::HTML(open(url))

doc.css("table.weather tbody tr").each do |row|
  cols = row.css("td")
  unless cols.length == 1 # ignore first row
    cols = cols.to_a.map { |c| c.text.gsub(/\s+/, " ").strip }
    values = create_hash(cols)
    if cols[0][0..1].codepoints == [160, 160] # starts with two &nbsp;s
      data[data.keys.last][:additional_parameters] = [] if data[data.keys.last][:additional_parameters] == nil
      data[data.keys.last][:additional_parameters] << values
    else
      data[cols[0].downcase.to_sym] = values
    end
  end
end

def value_to_f(str, num_match=0)
  str.scan(/\d*\.\d*/)[num_match].to_f
end

## transform stuff! and create something reasonable
out = {}

out[:timestamp] = Time.parse(data[:messzeit][:value]) #+
out[:measurements] = {
  temperature: {
   # value: data[:lufttemperatur][:value][/\d*\.\d*/].to_f,
    value: value_to_f(data[:lufttemperatur][:value]),
    unit: "Degree Celsius",
    description: "15m AGL"
  },
  relative_humidity: {
    value: data[:"relative luftfeuchte"][:value][/\d*\.\d*/].to_f,
    unit: "Percentage",
    description: "15m AGL"
  },
  atmospheric_pressure: {
    value: data[:luftdruck][:value][/\d*\.\d*/].to_f,
    unit: "hectopascals",
    description: "85m above standard elevation zero"
  },
  wind_speed: {
    values: [
      {
        value: value_to_f(data[:windgeschwindigkeit][:value]),
        unit: "meters per second"
      },
      {
        value: value_to_f(data[:windgeschwindigkeit][:value], 1),
        unit: "kilometers per second"
      }
    ],
    description: "15m AGL"
  
}


binding.pry

