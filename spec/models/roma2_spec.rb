#require 'spec_helper'
require_relative 'basic_spec'

puts "Model test(roma_spec_rbalse.rb)**********************"
puts "  please wait a moment..."

describe Roma do
#[Cluster function check](ph3)=================================================================
    roma = Roma.new
    roma.stats

    routing_list = roma.get_instances_list
    target_instance = ""
    routing_list["active"].each{|instance|
      if instance != "#{ConfigGui::HOST}_#{ConfigGui::PORT}"
        target_instance = instance 
        break
      end
    }

    sock = TCPSocket.open(target_instance.split("_")[0], target_instance.split("_")[1])
    sock.write("rbalse\r\n")
    sock.close
    sleep 20 # should wait over [routing.fail_cnt_threshold] * [routing.fail_cnt_gap]

    roma.stats # update @stats_hash
    routing_list = roma.get_instances_list # update

    context "inactive(one instance's status is inactive)" do

      it_should_behave_like 'get_instances_list_check', routing_list, "abnormal"

      each_instance_status = roma.get_instances_info(routing_list, "status")
      it_should_behave_like 'get_instances_info_check', each_instance_status, "status", target_instance

      each_instance_size = roma.get_instances_info(routing_list, "size")
      it_should_behave_like 'get_instances_info_check', each_instance_size, "size", target_instance

      each_instance_version = roma.get_instances_info(routing_list, "version")
      it_should_behave_like 'get_instances_info_check', each_instance_version, "version", target_instance
    end

end # End of describe
