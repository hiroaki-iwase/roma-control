require 'spec_helper'

describe ApiController do
  describe "GET 'get_parameter" do
    before do
      get 'get_parameter'
    end

    it "returns http success(200)" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "get correct infomation" do
      hash = JSON.parse(response.body)
      expect(hash['stats']['name']).to eq('ROMA')
      expect(hash.size).to be 7
      hash.each{|key, value|
        expect(hash[key].class).to eq Hash
        expect(hash[key].size).to be > 0
      }
    end
  end
end
