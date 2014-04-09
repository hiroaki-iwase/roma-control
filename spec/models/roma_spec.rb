require 'spec_helper'

describe Roma do
  context "stats_result" do
    res = Roma.new.stats

    it { expect(res).to be_a_kind_of(Hash) } # Hash or Not
    it "stats_hash have 7 parent column " do
      ## Config, Stats, Storage[roma], Write-behind, Routing, Connection, others
      expect(res.size).to be 7
    end

    res.each{|k1, v1|
      v1.each{|k2, v2|
        it { expect(res[k1][k2]).not_to be_nil }
      }
    }
  end

  context "dynamic_command(normal)" do
    roma = Roma.new
    res_normal = roma.change_param("pool_expire_time", 777)

    it { expect(res_normal).to be_a_kind_of(Hash) }
    it { expect(res_normal.size).to be > 1 } 
    res_normal.values.each{|v| 
      it { expect(v.chomp).to eq("STORED") }
    }

    actual_stats_normal = Roma.new.stats["connection"]["pool_expire_time"].chomp
    it { expect(actual_stats_normal).to eq("777") }
  end
 
  context "dynamic_command(in case of param error)", :focus => true do
    roma = Roma.new
    it { expect { roma.change_param("EMpool_maxlength", -777) }.not_to raise_error}
    #it { expect(roma.errors.full_messages[0]).to eq("Empool maxlength was not updated. Unexpection Error( CLIENT_ERRORlengthmustbegreaterthanzero\r\n ).") }
    actual_stats_under0 = Roma.new.stats["connection"]["pool_expire_time"].chomp
    it "confirm not changing" do 
      expect(actual_stats_under0).to eq("777")
    end
  end

  share_examples_for 'validation check' do |key, value, pattern|
    let(:roma) { Roma.new(key => value) }
    case pattern
    when "normal"
      it "normal test" do
        expect(roma.valid?).to be_true
      end
    when "under0", "Character", "nil", "Over Length"
      it "#{pattern} check" do
        expect(roma.valid?).to be_false
      end
    end  
  end

  context "dynamic_command_validation_normal" do
    it_should_behave_like 'validation check', "pool_expire_time", 777, "normal"
    it_should_behave_like 'validation check', "pool_expire_time", -777, "under0"
    it_should_behave_like 'validation check', "pool_expire_time", "aaa", "Character"
    it_should_behave_like 'validation check', "pool_expire_time", nil, "nil"
    it_should_behave_like 'validation check', "pool_expire_time", 9999999999, "Over Length"
  end

end # End of describe
