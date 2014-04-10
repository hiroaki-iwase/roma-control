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


  share_examples_for 'dynamic cmd check' do |key, value, pattern|
    let(:roma) { Roma.new(key => value) }
    case pattern
    when "normal"
      it "normal test" do
        expect(roma.valid?).to be_true
      end
    when "under0", "Over Limit", "Character", "nil", "Over Length", "Unexpected"
      it "#{pattern} check" do
        expect(roma.valid?).to be_false
      end
    else
      raise
    end
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
 
  context "dynamic_command(in case of param error)" do
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
      if key == "dns_caching" || key == "auto_recover" || key == "lost_action"
        it "[normal test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
          expect(roma.check_param(key, value)).to be_true
        end
      else
        it "[normal test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
          expect(roma.valid?).to be_true
        end
      end
    when "under0", "Over Limit", "Character", "Over Length", "Unexpected"
      if key == "dns_caching" || key == "auto_recover" || key == "lost_action"
        it "[error test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
          expect(roma.check_param(key, value)).to be_false
        end
      else
        it "[error test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
          expect(roma.valid?).to be_false
        end
      end
    when "nil"
      it "[error test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
        expect(roma.check_param(key, value)).to be_false
      end
    else
      raise
    end
  end

  columns = [
    "size_of_zredundant", 
    "hilatency_warn_time", 
    "spushv_klength_warn", 
    "spushv_vlength_warn", 
    "routing_trans_timeout", 
    "shift_size", 
    "fail_cnt_threshold", 
    "fail_cnt_gap", 
    "accepted_connection_expire_time", 
    "pool_maxlength", 
    "pool_expire_time", 
    "EMpool_maxlength", 
    "EMpool_expire_time",
    "dns_caching",
    "auto_recover"
  ]

  columns.each{|column|
    context "dynamic_command_validation_normal" do 
      if column == "dns_caching" || column == "auto_recover"
        it_should_behave_like 'validation check', column, "true",  "normal"
        it_should_behave_like 'validation check', column, "false", "normal"
        it_should_behave_like 'validation check', column, "on", "Unexpected"
        it_should_behave_like 'validation check', column, "hogehoge", "Character"
        it_should_behave_like 'validation check', column, nil, "nil"
      else
        it_should_behave_like 'validation check', column, 50, "normal"
        it_should_behave_like 'validation check', column, -50,        "under0"
        it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
        it_should_behave_like 'validation check', column, "hogehoge", "Character"
        it_should_behave_like 'validation check', column, nil,        "nil"
      end
    end
  }


  specific_columns = [
    "dcnice", 
    "descriptor_table_size", 
    "continuous_limit",
    "sub_nid",
    "lost_action"
  ]

  specific_columns.each{|column|
    #context "dynamic_command_validation_normal", :focus => true do
    context "dynamic_command_validation_normal" do
      if column == "dcnice"
        it_should_behave_like 'validation check', column, 5,  "normal"
        it_should_behave_like 'validation check', column, 10, "Over Length"
        it_should_behave_like 'validation check', column, -50,        "under0"
        it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
        it_should_behave_like 'validation check', column, "hogehoge", "Character"
        it_should_behave_like 'validation check', column, nil,        "nil"
      elsif column == "descriptor_table_size"
        it_should_behave_like 'validation check', column, 2048,  "normal"
        it_should_behave_like 'validation check', column, -50,        "under0"
        it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
        it_should_behave_like 'validation check', column, "hogehoge", "Character"
        it_should_behave_like 'validation check', column, nil,        "nil"
      elsif column == "continuous_limit"
        it_should_behave_like 'validation check', column, "500:60:700", "normal"
        it_should_behave_like 'validation check', column, "-500:60:700", "under0"
        it_should_behave_like 'validation check', column, "500:-60:700", "under0"
        it_should_behave_like 'validation check', column, "500:60:-700", "under0"
        it_should_behave_like 'validation check', column, "5000:60:700", "Over Limit"
        it_should_behave_like 'validation check', column, "500:600:700", "Over Limit"
        it_should_behave_like 'validation check', column, "500:60:7000", "Over Limit"
        it_should_behave_like 'validation check', column, "hoge:60:700", "Character"
        it_should_behave_like 'validation check', column, "500:hoge:700", "Character"
        it_should_behave_like 'validation check', column, "500:60:hoge", "Character"
        it_should_behave_like 'validation check', column, nil, "nil"
      elsif column == "sub_nid"
        it_should_behave_like 'validation check', column, "127.0.0.0/24 192.168.10.202 127.0.0.1", "normal"
        it_should_behave_like 'validation check', column, "1111.2222.3333.4444/24 192.168.10.202 127.0.0.1", "Over Limit"
        it_should_behave_like 'validation check', column, nil, "nil"
      elsif column == "lost_action"
        it_should_behave_like 'validation check', column, "auto_assign", "normal"
        it_should_behave_like 'validation check', column, "shutdown", "normal"
        it_should_behave_like 'validation check', column, "no_action", "Unexpected"
        it_should_behave_like 'validation check', column, "hogehoge", "Character"
        it_should_behave_like 'validation check', column, nil, "nil"
      end
    end
  }

end # End of describe
