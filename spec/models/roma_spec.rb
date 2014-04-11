#require 'spec_helper'
require_relative 'basic_spec'

describe Roma do

#[Status check](ph1)=================================================================
  #context "stats_result", :focus => true do
  context "stats_result" do
    res = Roma.new.stats

    it { expect(res).to be_a_kind_of(Hash) } # Hash or Not
    it "stats_hash have 7 parent column " do
      ## Config, Stats, Storage[roma], Write-behind, Routing, Connection, others
      expect(res.size).to be 7
    end
    
    it "check all param have value(not have nil)" do
      res.each{|k1, v1|
        v1.each{|k2, v2|
          expect(res[k1][k2]).not_to be_nil
        }
      }
    end
  end

#[Dynamic command check](ph2)=================================================================
  share_examples_for 'dynamic cmd check' do |key, value, group, pattern|
    let(:roma) { Roma.new }
    let(:dynamic) { roma.change_param(key, value) }
    let(:actual_stats_normal) { roma.stats }
  
    # return message check
    it "Return param check[key=>#{key} / value = #{value} / check pattern=> Hash or not]" do
      expect(dynamic).to be_true
    end
    it "Return param check[key=>#{key} / value = #{value} / check pattern=> Size > 1]" do
      expect(dynamic.size).to be > 1
    end
    it "Return param check[key=>#{key} / value = #{value} / check pattern=> msg is 'STORED']" do
      dynamic.values.each{|v|
        if key == "dns_caching"
          expect(v.chomp).to eq("ENABLED")
        elsif key == "sub_nid"
          expect(v.chomp).to eq("ADDED")
        else
          expect(v.chomp).to eq("STORED")
        end
      }
    end
  
    # check reflected or not
    case pattern
    when "string"
      it "Reflected check[key=>#{key} / value = #{value}]" do
        if key == "sub_nid"
          sub_value = value.split(nil)
          sub_value = "{\"#{sub_value[0]}\"=>{:regexp=>\"#{sub_value[1]}\", :replace=>\"#{sub_value[2]}\"}}"
          expect(actual_stats_normal[group][key].chomp ).to eq(sub_value)
        else
          expect(actual_stats_normal[group][key].chomp ).to eq(value)
        end
      end
    when "boolean"
      it "Reflected check[key=>#{key} / value = #{value}]" do
        expect(actual_stats_normal[group][key].chomp ).to eq(value)
      end
    else
      raise
    end
  end # end of example "dynamic cmd check"
  
  
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
          err = error_msg(key)
          expect(roma.errors.full_messages[0]).to eq(err)
        end
      end
    when "nil"
      it "[error test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
        expect(roma.check_param(key, value)).to be_false
      end
    else
      raise
    end
  end # end of example "validation check"
  
  def error_msg(key)
    case key
    when "dcnice"
      "#{key.capitalize.gsub(/_/, " ")}  : You sholud input a priority from 1 to 5."
    when "size_of_zredundant", "spushv_klength_warn", "spushv_vlength_warn", "shift_size"
      "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 2147483647."
    when "hilatency_warn_time"
      "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 60."
    when "routing_trans_timeout", "accepted_connection_expire_time", "pool_expire_time", "EMpool_expire_time"
      "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 86400."
    when "fail_cnt_threshold"
      "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 100."
    when "fail_cnt_gap"
      "#{key.capitalize.gsub(/_/, " ")}  : number must be from 0 to 60."
    when "pool_maxlength", "EMpool_maxlength"
      "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1 to 1000."
    when "descriptor_table_size"
      "#{key.capitalize.gsub(/_/, " ")}  : number must be from 1024 to 65535."
    when "sub_nid"
      "#{key.capitalize.gsub(/_/, " ")}  : Target NetMask is no more than 20 characters."
    when "lost_action"
      "#{key.capitalize.gsub(/_/, " ")}  : Unexpected Error. This value is required"
    #when "continuous_limit1"
    #  "Continuous limit  : All fields must be number and required."
    #when "continuous_limit2"
    #  "Continuous limit  : nubmer must be from 1 to 1000."
    #when "continuous_limit3"
    #  "Continuous limit  : nubmer must be from 1 to 100."
    else
      raise
    end
  end

  columns = {
    "stats" => [
      "size_of_zredundant",
      "hilatency_warn_time",
      "spushv_klength_warn",
      "spushv_vlength_warn",
      "routing_trans_timeout"
    ],
    "write-behind" => [
      "shift_size"
    ],
    "routing" => [
      "fail_cnt_threshold",
      "fail_cnt_gap",
      "auto_recover"
    ],
    "connection" => [
      "accepted_connection_expire_time",
      "pool_maxlength",
      "pool_expire_time",
      "EMpool_maxlength",
      "EMpool_expire_time"
    ],
    "others" => [
      "dns_caching"
    ]
  }

  columns.each{|group, column_ary|
    column_ary.each{|column|
      #context "dynamic_command_validation_normal", :focus => true do
      context "dynamic_command_validation_normal" do

        if column == "dns_caching" || column == "auto_recover"
          it_should_behave_like 'dynamic cmd check', column, "true", group, "boolean"
          it_should_behave_like 'validation check', column, "true",  "normal"
          it_should_behave_like 'validation check', column, "false", "normal"
          it_should_behave_like 'validation check', column, "on", "Unexpected"
          it_should_behave_like 'validation check', column, "hogehoge", "Character"
          it_should_behave_like 'validation check', column, nil, "nil"
        else
          if column == "hilatency_warn_time" || column == "fail_cnt_gap" || column == "routing_trans_timeout"
            it_should_behave_like 'dynamic cmd check', column, "40.0", group, "string"
          else
            it_should_behave_like 'dynamic cmd check', column, "40", group, "string"
          end
          #it_should_behave_like 'dynamic cmd check(error msg)', column, -500 if column == "EMpool_maxlength"
          it_should_behave_like 'validation check', column, 50, "normal"
          it_should_behave_like 'validation check', column, -50,        "under0"
          it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
          it_should_behave_like 'validation check', column, "hogehoge", "Character"
          it_should_behave_like 'validation check', column, nil,        "nil"
        end
      end
    }
  }


  specific_columns = {
    "stats" => [
      "dcnice"
    ],
    "connection" => [
      "descriptor_table_size",
      "continuous_limit"
    ],
    "routing" => [
      "sub_nid",
      "lost_action"
    ]
  }

  specific_columns.each{|group, column_ary|
    column_ary.each{|column|
      #context "dynamic_command_validation_normal", :focus => true do
      context "dynamic_command_validation_normal" do
        if column == "dcnice"
          it_should_behave_like 'dynamic cmd check', column, 4, group, "string"
          it_should_behave_like 'validation check', column, 5,  "normal"
          it_should_behave_like 'validation check', column, 10, "Over Length"
          it_should_behave_like 'validation check', column, -50,        "under0"
          it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
          it_should_behave_like 'validation check', column, "hogehoge", "Character"
          it_should_behave_like 'validation check', column, nil,        "nil"
        elsif column == "descriptor_table_size"
          it_should_behave_like 'dynamic cmd check', column, 2048, group, "string"
          it_should_behave_like 'validation check', column, 4096,  "normal"
          it_should_behave_like 'validation check', column, -50,        "under0"
          it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
          it_should_behave_like 'validation check', column, "hogehoge", "Character"
          it_should_behave_like 'validation check', column, nil,        "nil"
        elsif column == "continuous_limit"
          it_should_behave_like 'dynamic cmd check', column, "600:80:800", group, "string"
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
          it_should_behave_like 'dynamic cmd check', column, "127.0.0.0/24 192.168.10.202 127.0.0.1", group, "string"
          it_should_behave_like 'validation check', column, "127.0.0.0/24 192.168.10.202 127.0.0.1", "normal"
          it_should_behave_like 'validation check', column, "1111.2222.3333.4444/24 192.168.10.202 127.0.0.1", "Over Limit"
          it_should_behave_like 'validation check', column, nil, "nil"
        elsif column == "lost_action"
          it_should_behave_like 'dynamic cmd check', column, "shutdown", group, "string"
          it_should_behave_like 'validation check', column, "auto_assign", "normal"
          it_should_behave_like 'validation check', column, "shutdown", "normal"
          it_should_behave_like 'validation check', column, "no_action", "Unexpected"
          it_should_behave_like 'validation check', column, "hogehoge", "Character"
          it_should_behave_like 'validation check', column, nil, "nil"
        else
          raise
        end
      end
    }
  }

#[Cluster function check](ph3)=================================================================


end # End of describe
