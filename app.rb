require "sinatra"
require "sinatra/reloader"
require "httparty"
def view(template); erb template.to_sym; end

get "/" do
    # Tampa, FL
  lat = 27.931350
  long = -82.522130

  units = "imperial" 
  key = "b665d47a55b7b1bdb8fa4ac4d636e889" 

  # construct the URL to get the API data (https://openweathermap.org/api/one-call-api)
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=#{units}&appid=#{key}"

  # make the call
  @forecast = HTTParty.get(url).parsed_response.to_hash

today = "Today: High of #{@forecast["daily"][0]["temp"]["max"]} and #{@forecast["daily"][0]["weather"][0]["description"]}"
tomorrow = "Tomorrow: High of #{@forecast["daily"][1]["temp"]["max"]} and #{@forecast["daily"][1]["weather"][0]["description"]}"

@days = [today] 
@days << tomorrow

latercast = []
day_number = 1
  for day in @forecast["daily"]
   latercast << "Day #{day_number}: High of #{day["temp"]["max"]} and #{day["weather"][0]["description"]}"
    day_number = day_number +1
end

@fiveday = latercast[2,3]


  ### Get the news
    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=15c0cc1323e247699790840958a3f6dd"
    @news = HTTParty.get(url).parsed_response.to_hash    
    @latest = @news["articles"][0,5]


view 'news' 
end
