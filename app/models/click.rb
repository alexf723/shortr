require "dynamo_data_source"
require "click"
require 'digest/sha1'
require 'short_url'
require "useragent"
require "geocoder"
require 'uri'

class Click
  
  include ActiveModel::Model
  
  attr_accessor :time, :country, :browser, :platform, :short_url, :unique_hash
  
  @data_source = Dynamo_data_source.instance
  
  STATS_TABLE_NAME = 'Statistics'
  URL_HASH_KEY = 'short_url'
  
  def self.record_click ( short_url, request )
    
    user_agent = UserAgent.parse(request.env['HTTP_USER_AGENT'])
    geocode_data =  Geocoder.search(request.remote_ip)[0]
    country = geocode_data.country_code.empty? ? "Unknown" : geocode_data.country_code
    unique_hash = short_url.short_url + ":" + Time.now.to_i.to_s + ":" + ( Digest::SHA1.hexdigest request.remote_ip )
    data = { :unique_hash => unique_hash, :short_url => short_url.short_url, :browser => user_agent.browser, 
      :platform => user_agent.platform, :time => Time.now.to_i, :country => country }
    @data_source.put_item( STATS_TABLE_NAME, data )
    Click.new( data )
    
  end
  
  def self.load_clicks ( short_url ) 
    
    clicks = []
    clicks_raw = @data_source.get_item_by_secondary_index( STATS_TABLE_NAME, URL_HASH_KEY, short_url )[:items]
    clicks_raw.each{ |click|
      puts click.inspect
      clicks << Click.new( click )
    }
    clicks
    
  end
  
end
