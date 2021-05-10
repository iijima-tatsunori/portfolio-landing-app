module StaticPagesHelper
  
  def landing_url
    require 'net/http'
    uri = URI.parse("https://www.jma.go.jp/bosai/forecast/data/forecast/030000.json")
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
    
    @reportDatetime = result[0]["reportDatetime"]
    
    @timeDefines = result[0]["timeSeries"][0]["timeDefines"]
    @weatherCodes = result[0]["timeSeries"][0]["areas"][2]["weatherCodes"]
    @weathers = result[0]["timeSeries"][0]["areas"][2]["weathers"]
    @winds = result[0]["timeSeries"][0]["areas"][2]["winds"]
    @waves = result[0]["timeSeries"][0]["areas"][2]["waves"]
    
    @precipitation_times = result[0]["timeSeries"][1]["timeDefines"]
    @precipitation_pops = result[0]["timeSeries"][1]["areas"][2]["pops"]
    
    
    
    temps_timeDefine = result[0]["timeSeries"][2]["timeDefines"][0]
    @judge_temps_datetime = DateTime.parse(temps_timeDefine)
    @temps_name = result[0]["timeSeries"][2]["areas"][2]["area"]["name"]
    
    @temps_timeDefine_size = result[0]["timeSeries"][2]["timeDefines"].size
    temp = result[0]["timeSeries"][2]["areas"][2]["temps"]
    if @temps_timeDefine_size == 4
      @temps = temp.drop(1)
    elsif @temps_timeDefine_size == 2
      @temps = temp
    end
    judge_precipitation_time = result[0]["timeSeries"][1]["timeDefines"][0]
    @judge_datetime = DateTime.parse(judge_precipitation_time)
  end
  
  
end
