module Idevices
  extend self

  def available_real_devices
    real_devices_list = Hash.new
    
    real_device_id_list=`idevice_id -l`
    
    real_device_id_list.split("\n").uniq.each do |d|
      device = device_info(d)
      real_devices_list.merge!(device)
    end
    real_devices_list
  end

  def available_simulators
    simulators_list = Hash.new

    simulator_list_raw=`instruments -s devices`
    
    simulator_list_raw.split("\n").each do |s|
      if s[0..1] == 'iP'
        parsed_s = /(iP.*?)\s\(([0-9]+\.[0-9])\)\s\[(.*?)\]\s\((.*)\)/.match(s)
        device_name = parsed_s[1]
        os_version = parsed_s[2]
        device_id = parsed_s[3]
        product_type =  parsed_s[4]
        if parsed_s[1].size >= 20  # Name is too long 
          os_version = /\((.*)\)/.match(parsed_s[1])[1]
        end
         simulators_list.merge!(device_name => {    device_id: device_id,
                                                  device_name: device_name,
                                                   os_version: os_version,
                                                 product_type: product_type})
      end
    end
    simulators_list
  end

  def available_devices
    available_real_devices.merge(available_simulators)
  end

  def device_info(udid)
    device_info_raw = `ideviceinfo -u #{udid}`
    if device_info_raw.lines.first.include?(udid)
      fail device_info_raw
    end
    device_name     = /DeviceName: (.*)\n/.match(device_info_raw)[1]
    product_name    = /ProductName: (.*)\n/.match(device_info_raw)[1]
    product_type    = /ProductType: (.*)\n/.match(device_info_raw)[1]
    product_version = /ProductVersion: (.*)\n/.match(device_info_raw)[1]
    wifi_address    = /WiFiAddress: (.*)\n/.match(device_info_raw)[1]
    wifi_ip_raw = `arp -a | grep #{wifi_address.gsub(':0', ':')}`
    wifi_ip_address = 'unknown'
    wifi_ip_raw = `arp -a | grep #{device_name.downcase + '.'}` if wifi_ip_raw == ''
     
    if wifi_ip_raw == ''
      warn "Can't find device #{udid} ip by MAC, try to reconnect wifi"
    else
      wifi_ip_address = /\((.*?)\)/.match(wifi_ip_raw)[1]
    end
    { 
      device_name => { 
                              device_id: udid,
                            device_name: device_name,
                           product_name: product_name,
                           product_type: product_type,
                             os_version: product_version,
                           wifi_address: wifi_address,
                        wifi_ip_address: wifi_ip_address
                      }
    }
  end

  def install_app(udid, app)
    `ideviceinstall -u #{udid} #{app}`
  end

  def uninstall_app(udid, app)
    `ideviceinstall -u #{udid} -U #{app}`
  end

end