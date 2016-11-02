require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    require 'json'

    address_1 = @street_address.gsub(" ","+")

    @url_google = "http://maps.googleapis.com/maps/api/geocode/json?address=" + address_1

    @parsed_data_google = JSON.parse(open(@url_google).read)

    @lat = @parsed_data_google["results"][0]["geometry"]["location"]["lat"]

    @lng = @parsed_data_google["results"][0]["geometry"]["location"]["lng"]

    address_2 = @lat.to_s + "," + @lng.to_s

    @url_darksky = "https://api.forecast.io/forecast/aa4f9052007acaad5d6137341fa9632e/" + address_2

    @parsed_data_darksky = JSON.parse(open(@url_darksky).read)

    @current_temperature = @parsed_data_darksky["currently"]["temperature"]

    @current_summary = @parsed_data_darksky["currently"]["summary"]

    @summary_of_next_sixty_minutes = @parsed_data_darksky["minutely"]["summary"]

    @summary_of_next_several_hours = @parsed_data_darksky["hourly"]["summary"]

    @summary_of_next_several_days = @parsed_data_darksky["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
