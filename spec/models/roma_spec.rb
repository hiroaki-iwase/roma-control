#require 'spec_helper'
require_relative 'basic_spec'

puts "[Model test(roma_spec.rb)]***************************"

begin
  env = Roma.new.get_stats
  raise if env["stats"]["enabled_repetition_host_in_routing"].chomp != "true"
  raise if env["routing"]["nodes.length"].to_i < 2
rescue
  prepare = <<-'EOS'
  [ROMA condition Error] 
    This test require the below conditions.
    If this error message was displayed, please check your ROMA status.
      1. ROMA is booting
      2. instance count should be over 2
      3. enabled_repetition_host_in_routing is true(--enabled_repeathost)
  EOS
  puts prepare
  exit!
end


describe Roma do
#[Status check](ph1)=================================================================
  #context "stats_result", :focus => true do
  context "stats_result" do
    res = Roma.new.get_stats

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
      context "dynamic_command_check[#{column}]=====================================" do
        if column == "dns_caching" || column == "auto_recover"
          it_should_behave_like 'dynamic cmd check', column, "true", group, "boolean"
          it_should_behave_like 'validation check', column, "true",     "normal"
          it_should_behave_like 'validation check', column, "false",    "normal"
          it_should_behave_like 'validation check', column, "on",       "Unexpected"
          it_should_behave_like 'validation check', column, "hogehoge", "Character"
          it_should_behave_like 'validation check', column, nil,        "nil"
        else
          #if column == "hilatency_warn_time" || column == "fail_cnt_gap" || column == "routing_trans_timeout"
          if column == "hilatency_warn_time" || column == "routing_trans_timeout"
            it_should_behave_like 'dynamic cmd check', column, "40.0", group, "string"
          elsif column == "fail_cnt_gap"
            it_should_behave_like 'dynamic cmd check', column, "1.0", group, "string"
          elsif column == "fail_cnt_threshold"
            it_should_behave_like 'dynamic cmd check', column, "5", group, "string"
          else
            it_should_behave_like 'dynamic cmd check', column, "40", group, "string"
          end
          it_should_behave_like 'validation check', column, 50,         "normal"
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
      context "dynamic_command_check(specific columns)[#{column}]=====================================" do
        if column == "dcnice"
          it_should_behave_like 'dynamic cmd check', column, "4", group, "string"
          it_should_behave_like 'validation check', column, 5,          "normal"
          it_should_behave_like 'validation check', column, 10,         "Over Length"
          it_should_behave_like 'validation check', column, -50,        "under0"
          it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
          it_should_behave_like 'validation check', column, "hogehoge", "Character"
          it_should_behave_like 'validation check', column, nil,        "nil"
        elsif column == "descriptor_table_size"
          it_should_behave_like 'dynamic cmd check', column, "2048", group, "string"
          it_should_behave_like 'validation check', column, 4096,       "normal"
          it_should_behave_like 'validation check', column, -50,        "under0"
          it_should_behave_like 'validation check', column, 9999999999, "Over Limit"
          it_should_behave_like 'validation check', column, "hogehoge", "Character"
          it_should_behave_like 'validation check', column, nil,        "nil"
        elsif column == "continuous_limit"
          it_should_behave_like 'dynamic cmd check', column, "600:80:800", group, "string"
          it_should_behave_like 'validation check', column, "500:60:700",  "normal"
          it_should_behave_like 'validation check', column, "-500:60:700", "under0", "con1" 
          it_should_behave_like 'validation check', column, "500:-60:700", "under0", "con2"
          it_should_behave_like 'validation check', column, "500:60:-700", "under0", "con3"
          it_should_behave_like 'validation check', column, "5000:60:700", "Over Limit", "con1"
          it_should_behave_like 'validation check', column, "500:600:700", "Over Limit", "con2"
          it_should_behave_like 'validation check', column, "500:60:7000", "Over Limit", "con3"
          it_should_behave_like 'validation check', column, "hoge:60:700",  "Character", "con0"
          it_should_behave_like 'validation check', column, "500:hoge:700", "Character", "con0"
          it_should_behave_like 'validation check', column, "500:60:hoge",  "Character", "con0"
          it_should_behave_like 'validation check', column, nil, "nil"
        elsif column == "sub_nid"
          it_should_behave_like 'dynamic cmd check', column, "127.0.0.0/24 192.168.10.202 127.0.0.1", group, "string"
          it_should_behave_like 'validation check', column, "127.0.0.0/24 192.168.10.202 127.0.0.1", "normal"
          it_should_behave_like 'validation check', column, "1111.2222.3333.4444/24 192.168.10.202 127.0.0.1", "Over Limit"
          it_should_behave_like 'validation check', column, nil, "nil"
        elsif column == "lost_action"
          it_should_behave_like 'dynamic cmd check', column, "shutdown", group, "string"
          it_should_behave_like 'validation check', column, "auto_assign", "normal"
          it_should_behave_like 'validation check', column, "shutdown",    "normal"
          it_should_behave_like 'validation check', column, "no_action",   "Unexpected"
          it_should_behave_like 'validation check', column, "hogehoge",    "Character"
          it_should_behave_like 'validation check', column, nil,           "nil"
        else
          raise
        end
      end
    }
  }

#[Cluster function check](ph3)=================================================================

    roma = Roma.new
    active_routing_list = roma.change_roma_res_style(roma.get_stats["routing"]["nodes"])

    context "normal(all instance's status is active)" do
      routing_info = roma.get_routing_info(active_routing_list)

      it_should_behave_like 'get_routing_info_check', routing_info
    end

    context "status change check(recover)" do
      sock = TCPSocket.open(ConfigGui::HOST, ConfigGui::PORT)
      sock.write("eval @stats.run_recover = true\r\n")

      routing_info = roma.get_routing_info(active_routing_list)
      routing_info.each{|instance, info|
        if instance == "#{ConfigGui::HOST}_#{ConfigGui::PORT}"
          it { expect(routing_info[instance]["status"]).to eq "recover" }
        else
          it { expect(routing_info[instance]["status"]).to eq "active" }
        end
      }
      sock.write("eval @stats.run_recover = false\r\n")
      sock.close
    end

    context "status change check(join)" do
      sock = TCPSocket.open(ConfigGui::HOST, ConfigGui::PORT)
      sock.write("eval @stats.run_join = true\r\n")

      routing_info = roma.get_routing_info(active_routing_list)
      routing_info.each{|instance, info|
        if instance == "#{ConfigGui::HOST}_#{ConfigGui::PORT}"
          it { expect(routing_info[instance]["status"]).to eq "join" }
        else
          it { expect(routing_info[instance]["status"]).to eq "active" }
        end
      }

      sock.write("eval @stats.run_join = false\r\n")
      sock.close
    end

    context "inactive(one instance's status is inactive)" do
      dummy_active_routing_list = active_routing_list - ["#{ConfigGui::HOST}_#{ConfigGui::PORT}"]

      routing_info = roma.get_routing_info(dummy_active_routing_list)
      routing_info.each{|instance, info|
        if instance == "#{ConfigGui::HOST}_#{ConfigGui::PORT}"
          it { expect(routing_info[instance]["status"]).to eq "inactive" }
          it { expect(routing_info[instance]["size"]).to eq nil }
          it { expect(routing_info[instance]["version"]).to eq nil }
        else
          it { expect(routing_info[instance]["status"]).to eq "active" }
        end
      }
    end

    context "change_roma_res_style(array)" do
      roma_res_example_array = '["192.168.223.2_10001", "192.168.223.2_10002", "192.168.223.2_10003"]'
      res_array = roma.change_roma_res_style(roma_res_example_array)

      it "Response is Array" do
        expect(res_array.class).to be Array
      end

      it "Size is same number" do
        expect(res_array.size).to be 3
      end

      it "confirm detail" do
        expect(res_array).to eq(["192.168.223.2_10001", "192.168.223.2_10002", "192.168.223.2_10003"])
      end
    end

    context "change_roma_res_style(hash)" do
      roma_res_example_hash = '{"192.168.223.2_10001"=>2062, "192.168.223.2_10002"=>2062, "192.168.223.2_10003"=>2062}'
      res_hash = roma.change_roma_res_style(roma_res_example_hash)

      it "Response is Hash" do
        expect(res_hash.class).to be Hash
      end

      it "Size is same number" do
        expect(res_hash.size).to be 3
      end

      it "value's class is fixnum" do
        res_hash.values.each{|value|
          expect(value).to be_a_kind_of(Fixnum)
        }
      end

      it "confirm detail" do
        expect(res_hash).to eq({"192.168.223.2_10001"=>2062, "192.168.223.2_10002"=>2062, "192.168.223.2_10003"=>2062})
      end
    end

    context "change_roma_res_style(Unexpected)" do
      roma_res_example_unexpected = 'hogehoge'

      it "in case of unexpected value was send" do
        expect { roma.change_roma_res_style(roma_res_example_unexpected) }.to raise_error
      end
    end

    context "status change check(recover)" do
      res = roma.send_command('recover', nil)
      res = roma.change_roma_res_style(res)

      it "Response is Hash" do
        expect(res.class).to be Hash
      end

      it "Hash size is same number of active node" do
        expect(res.size).to be active_routing_list.size
      end

      it "All instance send back 'STARTED'" do
        res.each{|key, value|
          expect(value).to eq "STARTED"
        }
      end

      it "All instance name is same of active node list'" do
        res.each{|key, value|
          expect(active_routing_list.include?(key)).to be_true
        }
      end
    end

    context "status change check(recover) in case of failed" do
      roma.send_command('eval @stats.run_recover = true', nil)
      res = roma.send_command('recover', nil)
      res = roma.change_roma_res_style(res)

      it "Response is Hash" do
        expect(res.class).to be Hash
      end

      it "Hash size is same number of active node" do
        expect(res.size).to be active_routing_list.size
      end

      it "1 instance send back 'SERVER_ERROR'" do
        expect(res.values.include?("SERVER_ERROR Recover process is already running.")).to be_true
      end

      it "All instance name is same of active node list'" do
        res.each{|key, value|
          expect(active_routing_list.include?(key)).to be_true
        }
      end

      roma.send_command('eval @stats.run_recover = false', nil)
    end

#[login & root cmd](ph4)=================================================================
    ConfigGui::ROOT_USER = [{:username => 'root', :password => 'rakuten', :email => 'dev-act-roma1@mail.rakuten.com'}]
    #ConfigGui::NORMAL_USER = [{:username => 'roma', :password => 'rit', :email => ''}]
    ConfigGui::NORMAL_USER = [
      {:username => 'roma1', :password => 'rit1', :email => ''},
      {:username => 'roma2', :password => 'rit2'},
    ]


    context "root login check(correct)" do
      username = 'root'
      password = 'rakuten'
      email = 'dev-act-roma1@mail.rakuten.com'
      expected_res = {:username => username, :password => password, :email => email}

      it { expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to eq expected_res }
    end

    context "root login check(incorrect user)" do
      username = 'hogehoge'
      password = 'rakuten'

      it { expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false }
    end

    context "root login check(incorrect password)" do
      username = 'root'
      password = 'fugafuga'

      it { expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false }
    end


    context "normal login check(correct)" do
      username = 'roma1'
      password = 'rit1'
      email = ''
      expected_res = {:username => username, :password => password, :email => email}

      it { expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to eq expected_res }
    end

    context "normal login check(correct)" do
      username = 'roma2'
      password = 'rit2'
      expected_res = {:username => username, :password => password}

      it { expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to eq expected_res }
    end

    context "normal login check(incorrect user)" do
      username = 'hogehoge'
      password = 'rit1'

      it { expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false }
    end

    context "normal login check(incorrect password)" do
      username = 'roma1'
      password = 'fugafuga'

      it { expect(User.authenticate(username, Digest::SHA1.hexdigest(password))).to be_false }
    end


end # End of describe
