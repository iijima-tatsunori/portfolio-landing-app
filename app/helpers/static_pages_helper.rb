module StaticPagesHelper
  
  def landing_url
    uri = URI.parse("https://www.jma.go.jp/bosai/forecast/data/forecast/030000.json")
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    
    @days = %w[今日 明日 明後日]
    @timeDefines = result[0]["timeSeries"][0]["timeDefines"]
    @weatherCodes = result[0]["timeSeries"][0]["areas"][2]["weatherCodes"]
    
    @publishingOffice = result[0]["publishingOffice"]
    @reportDatetime = result[0]["reportDatetime"]
    @timeSeries_name = result[0]["timeSeries"][0]["areas"][2]["area"]["name"]
    @timeSeries_weathers = result[0]["timeSeries"][0]["areas"][2]["weathers"]
    @timeSeries_waves = result[0]["timeSeries"][0]["areas"][2]["waves"]
    @timeSeries_winds = result[0]["timeSeries"][0]["areas"][2]["winds"]
    
    @result = result[1]["timeSeries"][1]["areas"][0]["area"]["name"]
    @result2 = result[1]["timeSeries"][1]["areas"][0]["tempsMin"]
  end
  
  def weather_icon(code)
    url = "https://www.jma.go.jp/bosai/forecast/img/#{code}.svg"
    # ready filepath
    dirName = "/app/assets/images/"
    # write image adata
    open(dirName, 'wb') do |output|
      open(url) do |data|
        output.write(data.read)
      end
    end
  end
  
end
