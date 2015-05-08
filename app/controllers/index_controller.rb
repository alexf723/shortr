class IndexController < ApplicationController
  
  def home
    
    puts params[:form_name]
    if params[:form_name] == 'create'
      create( params ) 
    end
    
  end
  
  def expand
    
    @short_url = Short_url.get_from_short_url( params[:short] ) 
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
    if !valid_url( long_url )
      params[:error] = "Invalid URL #{long_url}"
      return
    end
    
    begin
      if !defined_short_url.nil? and !defined_short_url.empty?
        @short_url = Short_url.create_short_url_with_defined( long_url, defined_short_url )
      else
        @short_url = Short_url.create_short_url( long_url )
      end
    rescue => e
      params[:error] = e.to_s + ":" + e.backtrace.to_s
    end
    
  end
  
  private
  
  def valid_url url
    return ( !url.nil? and !url.empty? and url =~ /\A#{URI::regexp(['http', 'https'])}\z/ )
  end
  
end
