require "addressable/uri"

class IndexController < ApplicationController
  
  def home
    
    if params[:form_name] == 'create'
      create( params ) 
    end
    
  end
  
  def expand
    
    short = params[:short]
    
    # if they pasted in the whole short url, and not just the key
    # pull out just the key
    if short.index(request.base_url+"/") == 0
      short = short[(request.base_url.length+1),short.length]
    end
    
    @short_url = Short_url.get_from_short_url( short ) 
    if @short_url.nil? or @short_url.long_url.nil?
      redirect_to "/index/not_found"
    else
      @click = Click.record_click( @short_url, request )
      redirect_to @short_url.long_url
    end
    
  end
  
  def not_found
    # nothing needed
  end
  
  def create params
    
    long_url = params[:url]
    defined_short_url = params[:defined_short_url]
    
    # check if the URL is valid
    if !is_valid_url( long_url )
      params[:error] = "Invalid URL #{long_url}"
      return
    else
      long_url = get_clean_url long_url
    end
    
    begin
      if !defined_short_url.nil? and !defined_short_url.empty?
        @short_url = Short_url.create_short_url_with_defined( long_url, defined_short_url )
      else
        @short_url = Short_url.create_short_url( long_url )
      end
    rescue => e
      params[:error] = e.to_s 
    end
    
  end
  
  #private
  
  def is_valid_url url
    
    if  url.nil? || url.empty?
      return false
    end
    
    begin 
      # this doesnt always work, as passing in "abcd" will append http:// to it and pass
      uri = Addressable::URI.parse(get_clean_url url)
      return !uri.host.nil? && !uri.scheme.nil? && ( uri.scheme.upcase == 'HTTP' || uri.scheme.upcase == 'HTTPS' )
    rescue Addressable::URI::InvalidURIError
      return false
    end
  end
  
  # return a good version of this url, or throw an exception if it is invalid
  
  def get_clean_url url
    
    # if it has a protocol, then it is good
    if !url.index("://").nil?
      return url
    else
      return  "http://" + url 
    end
  end
  
end
