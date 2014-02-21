module StatHelper

  def check_skip_columns(column)
    if /^storage\[\d*\]/ =~ column
      return true
    end
  end

  def explanation(column)
    case column
      when "DEFAULT_LOST_ACTION"
        return <<-EOS
          DEFAULT_LOST_ACTION specifies the default action when ROMA loses data by server trouble.<br>
          <br>
          <U>no_action</U>:<br>ROMA denies access to lost data.<br>
          <U>auto_assign</U>:<br>ROMA can access the data as if the lost data never existed.<br>
          <U>shutdown</U>:<br>ROMA will shutdown if the data is lost.
        EOS
      when "LOG_SHIFT_AGE"
        return <<-EOS
       	  Specify number of log files which are rotated. 
        EOS
      when "LOG_SHIFT_SIZE"
        return <<-EOS
          Specify size (in bytes) of the log files.<br>
          When the log file reaches this size, it will rotate to the next file. 
        EOS
      when "LOG_PATH"
        return <<-EOS
          Specify directory that ROMA create log files in.<br>
          The default directory is current directory. 
        EOS
      when "RTTABLE_PATH"
        return <<-EOS
          Specify directory for ROMA to retrieve routing information file.<br>
          Default directory is current directory. 
        EOS
      when "STORAGE_DELMARK_EXPTIME"
        return <<-EOS
          Specify interval (in seconds) in which the deleted value is collected by GC.<br>
          Default is 5 days. 
        EOS
      when "STORAGE_EXCEPTION_ACTION"
        return <<-EOS
          Choose the action which ROMA takes if the storage encounters Exception Error.<br>
          <br>
          <U>no_action</U>: Nothing will occur.<br>
          <U>shutdown</U>: ROMA will shutdown. 
        EOS
      when "DATACOPY_STREAM_COPY_WAIT_PARAM"
        return <<-EOS
          Specify waiting time (in seconds) to copy the data slowly between nodes.
        EOS
      when "PLUGIN_FILES"
        return <<-EOS
          Specify plugin which are read, when ROMA process is started. 	
        EOS
      when "WRITEBEHIND_PATH"
        return <<-EOS
          Specify directory for ROMA to create event log files asynchronously.<br>
          Default directory is "./wb" directory. 
        EOS
      when "WRITEBEHIND_SHIFT_SIZE"
        return <<-EOS
          Specify size (in bytes) of the event log files.<br>
           When log file reaches this size, then log file rotates to the next file.<br>
          Default size is 10MB.
        EOS
      when "CONNECTION_DESCRIPTOR_TABLE_SIZE"
        return <<-EOS
          Specify the maximum number of FD when ROMA use epoll system-call.<br>
          When ROMA is using "CONNECTION_USE_EPOLL = true", this parameter is necessary.<br>
          This value must be smaller than OS settings.
        EOS
      when "config_path"
        return <<-EOS
       	  PATH of configuration file.<br>
          Which is referred when ROMA booting.
        EOS
      when "address"
        return <<-EOS
       	  Address of ROMA server which you refer to
        EOS
      when "port"
        return <<-EOS
       	  Port of ROMA which you refer to
        EOS
      when "daemon"
        return <<-EOS
       	  booting with daemon mode
        EOS
      when "name"
        return <<-EOS
       	  Your ROMA's name.<br>
          Defalut is "ROMA"
        EOS
      when "verbose"
        return <<-EOS
       	  Detail log mode.<br>
          which output many infomation than the debug log mode.
        EOS
      when "enabled_repetition_host_in_routing"
        return <<-EOS
       	  This option allow booting ROMA in only 1server.<br>
          Unless this option, data redundancy keep in multi servers.
        EOS
      when "run_recover"
        return <<-EOS
       	  Recovering process going or not.
        EOS
      when "run_sync_routing"
        return <<-EOS
       	  Sync_routing process going or not.
        EOS
      when "run_iterate_storage"
        return <<-EOS
       	  Iterate_storage process going or not.
        EOS
      when "run_storage_clean_up"
        return <<-EOS
       	  Storage_clean_up process going or not.
        EOS
      when "run_receive_a_vnode"
        return <<-EOS
       	  Instance is getting vnodes or not.
        EOS
      when "run_release"
        return <<-EOS
       	  Release process is going or not.
        EOS
      when "run_join"
        return <<-EOS
       	  Join process is going or not.
        EOS
      when "run_balance"
        return <<-EOS
       	  Balance process is going or not.
        EOS
      when "last_clean_up"
        return <<-EOS
       	  Date of last executing of clean up storage.
        EOS
      when "last_clean_up"
        return <<-EOS
       	  Date of last executing of clean up storage.
        EOS
      when "spushv_protection"
        return <<-EOS
       	  In case of true, this instance deny the spushv command.
        EOS
      when "stream_copy_wait_param"
        return <<-EOS
       	  Specify waiting time (in seconds) to copy the data slowly between nodes.
        EOS
      when "dcnice"
        return <<-EOS
          This number decide belows value setting.<br>
       	  <U>when n ==1</U> # highest priority   <br>
            &emsp; stream_copy_wait_param = 0.001  <br>
            &emsp; each_vn_dump_sleep = 0.001      <br>
            &emsp; each_vn_dump_sleep_count = 1000 <br>
                                          <br>
          <U>when n == 2</U>                     <br>
            &emsp; stream_copy_wait_param = 0.005  <br>
            &emsp; each_vn_dump_sleep = 0.005      <br>
            &emsp; each_vn_dump_sleep_count = 100  <br>
                                          <br>
          <U>when n == 3</U> # default priority  <br>
            &emsp; stream_copy_wait_param = 0.01   <br>
            &emsp; each_vn_dump_sleep = 0.001      <br>
            &emsp; each_vn_dump_sleep_count = 10   <br>
                                          <br>
          <U>when n == 4</U>                     <br>
            &emsp; stream_copy_wait_param = 0.01   <br>
            &emsp; each_vn_dump_sleep = 0.005      <br>
            &emsp; each_vn_dump_sleep_count = 10   <br>
                                          <br>
          <U>when n == 5</U> # lowest priority   <br> 
            &emsp; stream_copy_wait_param = 0.01   <br>
            &emsp; each_vn_dump_sleep = 0.01       <br>
            &emsp; each_vn_dump_sleep_count = 10
        EOS
      when "clean_up_interval"
        return <<-EOS
          Specify interval to delete data which have del flg.
        EOS
      when "size_of_zredundant"
        return <<-EOS
          Specify the maximum size (in bytes) of data.<br>
          While data is forwarded to other nodes for redundancy, data that exceed this size will be compressed before forwarding.<br>
          Default data size is 0.<br>
          If the value is 0 then the data will not be compressed. 
        EOS
      when "write_count"
        return <<-EOS
       	  Count of writing.
        EOS
      when "read_count"
        return <<-EOS
       	  Count of reading.
        EOS
      when "delete_count"
        return <<-EOS
       	  Count of deleting.
        EOS
      when "out_count"
        return <<-EOS
       	  Count of deleting record (as a primary node).
        EOS
      when "out_message_count"
        return <<-EOS
       	  Count of deleting record (as a secondary node).
        EOS
      when "redundant_count"
        return <<-EOS
       	  Count of getting [rset|rzset] command.<br>
          These command send from primary node's instance to secondary node's instance.         
        EOS
      when "hilatency_warn_time"
        return <<-EOS
          Specify time (in seconds) to which decide the normal limit of executing time of command.<br>
       	  if some operation take time over this setting second,<br>
          Error log will be output.
        EOS
      when "wb_command_map"
        return <<-EOS
       	  Target command list of write-behind func
        EOS
      when "latency_log"
        return <<-EOS
       	  Latency checking is working or not.
        EOS
      when "latency_check_cmd"
        return <<-EOS
       	  Target command of latency checking.
        EOS
      when "latency_check_time_count"
        return <<-EOS
          Specify the interval to calculate the latency average.
        EOS
      when "spushv_klength_warn"
        return <<-EOS
          Specify the limit size of key length.<br>
       	  When target key size over the this setting, warning log will be output.<br>
          During the vnode copy.(ex.recover, join)
        EOS
      when "spushv_vlength_warn"
        return <<-EOS
          Specify the limit size of value length.<br>
       	  When target value size over the this setting, warning log will be output.<br>
          During the vnode copy.(ex.recover, join)
        EOS
      when "spushv_read_timeout"
        return <<-EOS
       	  Specify the coefficient of Timeout time by using spushv command.<br>
          Timeout time = (handler.timeout * spushv_read_timeout)<br>
          Defalut timeout time is 1000(sec).<br>
          10 * 100 = 1000
        EOS
      when "reqpushv_timeout_count"
        return <<-EOS
       	  Specify the coefficient of Timeout time of getting vnode.<br>
          Next request send when last request is finished or this timeout time is elasped.<br>
          Timeout time is (0.1 * reqpushv_timeout_count).
        EOS
      when "routing_trans_timeout"
        return <<-EOS
       	  Specify the transaction time of routing change.<br>
          When over the this setting time, routing will be rollback.
        EOS
      when "storage.storage_path"
        return <<-EOS
       	  Specify directory that ROMA should create storage files in.<br>
          This is required when ROMA select file-based storage implementation.<br>
          Default directory is current directory.
        EOS
      when "storage.divnum"
        return <<-EOS
       	  Specify the number which divides the storage of ROMA process.
        EOS
      when "storage.option"
        return <<-EOS
       	  <U>bnum</U>   : <br>
                          count of keys which locate in first line of tc file.<br>
                          Basically not change.<br>
                          <br>
          <U>xmsiz</U>  : <br> 
                          rate of memory using in each tc files.<br>
                          If data size over this value, disk access will occure.<br>
                          <br>
          <U>opts</U>   : <br>
                          l => Support large file(over the 2GB)<br>
                          d => bz decompression. it decrease tc files amount.<br>
                          <br>
          <U>dfunit</U> : <br>
                          Unit of defrag. Basically not change.
        EOS
      when "storage.each_vn_dump_sleep"
        return <<-EOS
       	  Specify the time of sleeping during v-nodes dump operations's iterate.
        EOS
      when "storage.each_vn_dump_sleep_count"
        return <<-EOS
       	  Specify the interval of executing sleeping during v-nodes dump operations's iterate.
        EOS
      when "storage.each_clean_up_sleep"
        return <<-EOS
       	  Specify the interval of sleep during iteration on cleanup.
        EOS
      when "storage.logic_clock_expire"
        return <<-EOS
          ROMA's data have date data & logic clock.<br>
          But sometimes some difference happen between date data & logic clock.<br>
          This setting specify the time lag to estimate which node's data is correct.
        EOS
      when "path"
        return <<-EOS
       	  Path of write-behind's file
        EOS
      when "shift_size"
        return <<-EOS
          specify size (in bytes) of the log files.<br>
          When the log file reaches this size, it will rotate to the next file.
        EOS
      when "do_write"
        return <<-EOS
          Write-Behind func is working or not.
        EOS
      when "redundant"
        return <<-EOS
       	  Count of redundancy.
        EOS
      when "nodes.length"
        return <<-EOS
       	  Counts of nodes.
        EOS
      when "nodes"
        return <<-EOS
       	  Node list of ROMA.
        EOS
      when "dgst_bits"
        return <<-EOS
       	  Counts of digest bits.
        EOS
      when "div_bits"
        return <<-EOS
          Specify the count of vnodes.<br>
       	  vnodes count = (2**x)
        EOS
      when "vnodes.length"
        return <<-EOS
       	  Count of the vnodes.
        EOS
      when "primary"
        return <<-EOS
       	  Count of the primary node which this instance have.
        EOS
      when "secondary"
        return <<-EOS
       	  Count of the secondary node which this instance have.
        EOS
      when "short_vnodes"
        return <<-EOS
       	  Count of short vnodes.<br>
       	  Short vnodes is the node which break the redundancy.<br>
          So this value should be 0 in general.
        EOS
      when "lost_vnodes"
        return <<-EOS
       	  Count of lost nodes.<br>
          This node's data was lost and ROMA can't access.<br>
          So this value should be 0 in general.
        EOS
      when "fail_cnt_threshold"
        return <<-EOS
       	  Threshold value for fail-over to occur.<br>
          When ROMA fails to get routing information the number of times which is specified in this parameter, ROMA will failover.
        EOS
      when "fail_cnt_gap"
        return <<-EOS
       	  Specify time (in seconds).<br> 
          When ROMA can't get the routing information while ROUTING_FAIL_CNT_GAP time elapse, ROMA counts up a counter for fail-over.
        EOS
      when "sub_nid"
        return <<-EOS
       	  Specify the conversion pattern of routing.
        EOS
      when "lost_action"
        return <<-EOS
       	  DEFAULT_LOST_ACTION specifies the default action when ROMA loses data by server trouble. <br>
          <br>
          <U>no_action</U>  : ROMA denies access to lost data.<br>
          <U>auto_assign</U>: ROMA can access the data as if the lost data never existed. <br>
          <U>shutdown</U>   : ROMA will shutdown if the data is lost.
        EOS
      when "auto_recover"
        return <<-EOS
       	  In case of true, ROMA will execute recover when short vnodes rise.
        EOS
      when "auto_recover_time"
        return <<-EOS
       	  Specify the waiting time to execute auto-recover after short vnode rising.
        EOS
      when "auto_recover_status"
        return <<-EOS
       	  <U>waiting</U>   : Nothing to do (Default) <br>
          <U>preparing</U> : prepare for execute recover(relate to auto_recover_time)<br>
          <U>executing</U> : executing recover
        EOS
      when "version_of_nodes"
        return <<-EOS
       	  ROMA version of each nodes.<br>
          Ex)version 0.8.13<br>
          &emsp; 0  << 16(bit_shift) = 0<br>
          &emsp; 8  << 8(bit shift)  = 2048<br>
          &emsp; 13.to_i             = 13<br>
          &emsp; ---------------------------<br>
          &emsp;                       2061
        EOS
      when "min_version"
        return <<-EOS
       	  Oldest version of instance in ROMA cluster.
        EOS
      when "count"
        return <<-EOS
       	  Connection counts of Eventmachine.
        EOS
      when "descriptor_table_size"
        return <<-EOS
       	  Specify the maximum number of FD when ROMA use epoll system-call.<br>
          When ROMA is using "CONNECTION_USE_EPOLL = true", this parameter is necessary.<br>
          This value must be smaller than OS settings.
        EOS
      when "continuous_limit"
        return <<-EOS
       	  Specify the upper limit of connections.<br>
          Specify the three colon separated values ''start:rate:full''<br>
          (Ex. '200(connections):30(%):300(connections)).<br>
          <U>start</U>:<br>
            &emsp; ROMA will disconnect unused connection with a probability of ''rate/100'',
                   when connection reach this value.<br>
          <U>full</U>:<br>
            &emsp; If the number of using connections reaches "full", ROMA will disconnect unused connections with a probability of 100%.<br>
        EOS
      when "accepted_connection_expire_time"
        return <<-EOS
       	  Specify time(in seconds).<br>
          When a connection which ROMA received isn't used while CONNECTION_EXPTIME seconds, ROMA will disconnect this connection.<br>
          If the value is 0, then ROMA will not disconnect.<br>
        EOS
      when "handler_instance_count"
        return <<-EOS
       	  Current connection counts.
        EOS
      when "pool_maxlength"
        return <<-EOS
          Specify the maximum number of connections which the connection pool of asynchronous connection keeps.<br>
        EOS
      when "pool_expire_time"
        return <<-EOS
          Specify time(in seconds).<br>
          When ROMA uses a connection pool of asynchronous connection,<br> 
          ROMA will disconnect the connection which isn't used while CONNECTION_POOL_EXPTIME seconds after the connection is returned to the pool.<br>
          This parameter should be smaller than CONNECTION_EXPTIME parameter.
        EOS
      when "EMpool_maxlength"
        return <<-EOS
          Specify the maximum number of connections which the connection pool of synchronous connection keeps.<br>
          The amount of synchronous connection depends on the traffic of client accesses.<br>
          The recommended value is approximately-same as the number of ROMA client pool settings, as a rough guide 10 to 15.
        EOS
      when "EMpool_expire_time"
        return <<-EOS
          Specify time(in seconds).<br>
          When ROMA uses a connection pool of synchronous connection,<br>
          ROMA will disconnect the connection which isn't used while CONNECTION_EMPOOL_EXPTIME seconds after the connection is returned to the pool.<br>
          The parameter should be smaller than CONNECTION_EXPTIME parameter.
        EOS
      when "version"
        return <<-EOS
       	  ROMA's version
        EOS
      when "dns_caching"
        return <<-EOS
          dns caching func is going or not.
       	  dns info keep in each instance as a cache.
        EOS
    end
  end

end
