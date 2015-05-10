class Short_url
  
  include ActiveModel::Model
  
  # max long size for this machine
  MAX_SIZE = (2**(0.size * 8 -2) -1) 
  URL_TABLE_NAME = 'Short_url'
  URL_HASH_KEY = 'short_url'
  
  attr_accessor :short_url, :long_url, :owner, :creation_date, :end_date
  
  @data_source = Dynamo_data_source.instance
  
  def self.get_from_short_url( short_url ) 
    values = Dynamo_data_source.instance.get_primary_key( URL_TABLE_NAME, URL_HASH_KEY, short_url ).item
    Short_url.new( values )
  end
  
  def self.create_short_url_with_defined( long_url, defined_short_url ) 
    if @data_source.exists( URL_TABLE_NAME, URL_HASH_KEY, defined_short_url ) 
      raise "Short url #{defined_short_url} already exists"
    elsif !valid_short_url( defined_short_url )
      raise "Invalid short url #{defined_short_url}: short url must be letters and numbers only"
    end
    create_internal_short_url( long_url, defined_short_url )
  end
  
  def self.create_short_url( long_url ) 
    create_internal_short_url( long_url, create_unique_key )
  end
  
  def self.valid_short_url( short_url )
    return ( short_url == short_url[/[a-zA-Z0-9]+/] )
  end
  
  private 
  
  def self.create_internal_short_url( long_url, short_url, owner = 'System' ) 
    creation_date = Time.now
    data = { :long_url => long_url, :short_url => short_url, :owner => owner, :creation_date => creation_date.to_i } 
    @data_source.put_item( URL_TABLE_NAME, data )
    puts data.inspect
    Short_url.new( data )
  end
  
  def self.create_unique_key
    # generate a key until we find one not in use
    while true
      key = rand(MAX_SIZE).base62_encode
      puts key
      if !@data_source.exists( URL_TABLE_NAME, URL_HASH_KEY, key )
        return key
      end
    end
    raise "Failure to create unique key"
  end
 
end
