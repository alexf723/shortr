require 'rails_helper'

RSpec.describe Short_url, :type => :model do
  
  describe "#valid_short_url" do
    
    it "valid_short_url with valid" do
      expect(Short_url.valid_short_url( "ACBDefgh12345" )).to eq(true)
    end
    
    it "valid_short_url with invalid" do
      expect(Short_url.valid_short_url( "A_CBDefgh12345" )).to eq(false)
      expect(Short_url.valid_short_url( "A-CBDefgh12345" )).to eq(false)
      expect(Short_url.valid_short_url( "A%CBDefgh12345" )).to eq(false)
    end
    
  end
  
end
