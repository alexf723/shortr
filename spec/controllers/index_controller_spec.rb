require 'rails_helper'

RSpec.describe IndexController, :type => :controller do

  describe "#is_valid_url" do
    
    it "checks valid http url" do
      expect(@controller.is_valid_url("http://www.test.com")).to eq(true)
    end
    
    it "checks valid https url" do
      expect(@controller.is_valid_url("https://www.test.com")).to eq(true)
    end
    
    it "checks valid url without http" do
      expect(@controller.is_valid_url("www.test.com")).to eq(true)
    end
    
    it "checks invalid protocol" do
      expect(@controller.is_valid_url("ftp://www.test.com")).to eq(false)
    end
    
    it "checks invalid url" do
      expect(@controller.is_valid_url("://www/test/com")).to eq(false)
    end
   
  end
  
  describe "#get_clean_url" do
    
    it "valid url doesnt change" do
      url = "http://www.test.com"
      expect(@controller.get_clean_url(url)).to eq(url)
    end
    
    it "missing http does change" do
      url = "www.test.com"
      expect(@controller.get_clean_url(url)).to eq("http://" + url)
    end
    
  end

end