require 'sinatra'
require 'geocoder'
require 'builder'

def cors_headers
  headers 'Access-Control-Allow-Origin' => '*'
  headers 'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS'
  headers 'Access-Control-Allow-Headers' => 'X-Requested-With'
end

options '/geocode' do
  cors_headers()
  200
end

get '/geocode' do
  cors_headers
  result = Geocoder.search(params[:address], components: 'administrative_area:GA|country:US', sensor: false,
    bounds: [[33.737147,-84.406634], [33.764125,-84.370361]])
  builder do |xml|
    xml.geocodeResults do
      xml.count result.size
      xml.results do
        result.each do |r|
          xml.result do
            xml.description r.data['formatted_address']
            loc = r.data['geometry']['location']
            xml.lat loc['lat']
            xml.lng loc['lng']
          end
        end
      end
    end
  end
end
