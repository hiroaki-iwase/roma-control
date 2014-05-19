require 'spec_helper'

puts "[Controller test(api_controller_spec.rb)]***************************"

begin
  routing_history = Roma.new.get_all_routing_list
  raise if routing_history.include?('77777')
rescue
  prepare = <<-'EOS'
  [ROMA condition Error]
    This test require the below conditions.
    If this error message was displayed, please check your ROMA status.
      1. ROMA is booting
      2. ROMA's port No. do NOT include '77777'
         (Rspec test use this port No.)
  EOS
  puts prepare
  exit!
end

describe ApiController do

  describe "GET get_parameter" do
    before do
      get 'get_parameter'
    end

    it "returns http success(200)" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "get correct infomation" do
      hash_correct = JSON.parse(response.body)
      expect(hash_correct['stats']['name']).to eq('ROMA')
      expect(hash_correct.size).to be 7
      hash_correct.each{|key, value|
        expect(hash_correct[key].class).to eq Hash
        expect(hash_correct[key].size).to be > 0
      }
    end
  end # End describe "GET get_parameter" 

  describe "GET 'get_parameter(with parameters)" do
    before do
      get 'get_parameter', {:host => ConfigGui::HOST, :port => ConfigGui::PORT }
    end

    it "returns http success(200)" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "get correct infomation" do
      hash_correct_params = JSON.parse(response.body)
      expect(hash_correct_params['stats']['name']).to eq('ROMA')
      expect(hash_correct_params.size).to be 7
      hash_correct_params.each{|key, value|
        expect(hash_correct_params[key].class).to eq Hash
        expect(hash_correct_params[key].size).to be > 0
      }
    end
  end # End of "GET 'get_parameter(with parameters)"

  describe "GET 'get_parameter(in case of exception)" do
    before do
      get 'get_parameter', { :host => ConfigGui::HOST, :port => 77777 }
    end

    it "returns http success(200)" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "get error information" do
      hash_exception = JSON.parse(response.body)
      expect(hash_exception.size).to be 1
      expect(hash_exception.keys).to eq(['status'])
      expect(hash_exception['status']).to eq("Connection refused - connect(2) for \"#{ConfigGui::HOST}\" port 77777")
    end
  end # End of describe

end # End of describe ApiController
