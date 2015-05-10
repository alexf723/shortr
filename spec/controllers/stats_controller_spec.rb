require 'rails_helper'

RSpec.describe StatsController, :type => :controller do
  
  describe "#add_count_to_hash" do
    
    it "validates add_count_to_hash" do
      hash = {}
      @controller.add_count_to_hash( hash, "A" )
      expect(hash["A"]).to eq(1)
      @controller.add_count_to_hash( hash, "A" )
      expect(hash["A"]).to eq(2)
    end
    
  end
  
end
