require 'spec_helper'

describe Roma do
  context "stats_result" do
    roma = Roma.new
    hash = roma.stats_hash
    #let(:roma) { Roma.new }
    #let(:hash) { roma.stats_hash }

    #roma.stats_hash["others"]["version"] = nil # debug

    it { expect(hash).to be_a_kind_of(Hash) } # Hash or Not
    it "stats_hash have over 6 parent column " do 
      # Config, Stats, Storage[roma], Write-behind, Routing, Connection, others
      expect(hash.size).to be 7
    end 

    hash.each{|k1, v1|
      v1.each{|k2, v2|
        it { expect(hash[k1][k2]).not_to be_nil }
      }
    }

  end # End of context  
end # End of describe
