require 'spec_helper'

shared_examples_for 'dynamic cmd check' do |key, value, group, pattern|
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


shared_examples_for 'validation check' do |key, value, pattern, continous_limit_pattern|
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
        err = error_msg(key,  continous_limit_pattern)
        expect(roma.errors.full_messages[0]).to eq(err)
      end
    else
      it "[error test] key=>#{key}, value=>#{value} / test pattern=>#{pattern} check" do
        expect(roma.valid?).to be_false
        err = error_msg(key,  continous_limit_pattern)
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


def error_msg(key, continous_limit_pattern = nil)
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
  when "dns_caching"
    "#{key.capitalize.gsub(/_/, " ")}  : Unexpected Error. This value is required"
  when "auto_recover"
    "#{key.capitalize.gsub(/_/, " ")}  : Unexpected Error. This value is required"
  when "continuous_limit"
    if  continous_limit_pattern == "con0"
      "#{key.capitalize.gsub(/_/, " ")}  : All fields must be number and required."
    elsif  continous_limit_pattern == "con1" || continous_limit_pattern == "con3"
      "#{key.capitalize.gsub(/_/, " ")}  : nubmer must be from 1 to 1000."
    elsif  continous_limit_pattern == "con2"
      "#{key.capitalize.gsub(/_/, " ")}  : nubmer must be from 1 to 100."
    end
  else
    raise
  end
end

shared_examples_for 'get_instances_list_check' do |routing_list, rule|
  it { expect(routing_list).to be_a_kind_of(Hash) } # Hash or Not
  it { expect(routing_list.size).to be 2 } # "active" & "inactive"
  it { expect(routing_list["active"]).to be_a_kind_of(Array) }
  it { expect(routing_list["active"].uniq!).to be nil } # duplicate check
  it { expect(routing_list["active"].size).to be > 0 }
  routing_list["active"].each{|instance|
    it { expect(instance).to match(/^[-\.a-zA-Z\d]+_[\d]+/) }
  }
  it { expect(routing_list["inactive"]).to be_a_kind_of(Array) }
  it { expect(routing_list["active"].uniq!).to be nil } # duplicate check

  if rule == "normal"
    it { expect(routing_list["inactive"].size).to be 0 }
  elsif rule  =~ /rbalse|recover/
    it { expect(routing_list["inactive"].size).to be > 0 }
    routing_list["inactive"].each{|instance|
      it { expect(instance).to match(/^[-\.a-zA-Z\d]+_[\d]+/) }
    }
  else
    raise
  end
end


shared_examples_for 'get_instances_info_check' do |data, column, removed_instance, expected_status|

  it { expect(data).to be_a_kind_of(Hash) } # Hash or Not
  it { expect(data.size).to be > 0 }
  it { expect(data.keys.uniq!).to be nil } # duplicate check
  data.each{|instance, param|
    it { expect(instance).to match(/^[-\.a-zA-Z\d]+_[\d]+/) }
    case column
    when "status"
      if instance == removed_instance
        it { expect(param).to eq "inactive" } 
      else
        it { expect(param).to eq expected_status }
      end
    when "size"
      if instance == removed_instance
        it { expect(param).to be nil }
      else
        it { expect(param).to be_a_kind_of(Fixnum) }
        it { expect(param).to be > 209715200 } # 1 tc file is over 20 MB at least
      end
    when "version"
      if instance == removed_instance
        it { expect(param).to be nil }
      else
        it { expect(param).to be_a_kind_of(String) }
        it { expect(param).to match(/^\d\.\d\.\d+$|^\d\.\d\.\d+\-p\d+$/) } #/^\d\.\d\.\d+\-p\d+$/ is for 0.8.13-p1
      end
    else
      raise
    end
  }

end # end of example "get_instances_info_check"

