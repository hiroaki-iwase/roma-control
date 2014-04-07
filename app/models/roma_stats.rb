class Roma_stats
  include ActiveModel::Model
  
  attr_accessor :dcnice,
    :size_of_zredundant,
    :hilatency_warn_time,
    :spushv_klength_warn,
    :spushv_vlength_warn,
    :routing_trans_timeout,
    :shift_size,
    :fail_cnt_threshold,
    :fail_cnt_gap,
    :sub_nid,
    :lost_action,
    :auto_recover,
    :descriptor_table_size,
    :continuous_limit,
    :accepted_connection_expire_time,
    :pool_maxlength,
    :pool_expire_time,
    :EMpool_maxlength,
    :EMpool_expire_time,
    :dns_caching

  validates :dcnice,
    allow_blank: true,
    :length => { :is => 1, :message =>'only integer' }
  validates :size_of_zredundant,
    allow_blank: true,
    :length => { :is => 1, :message =>'only integer' }
  validates :hilatency_warn_time,
      allow_blank: true,
      :length => { :is => 1, :message =>'only integer' }
  validates :spushv_klength_warn, :spushv_vlength_warn,
    allow_blank: true,
    :length => { :is => 1, :message =>'only integer' }
  validates :routing_trans_timeout,
    allow_blank: true,
    :length => { :is => 1, :message =>'only integer' }
end
