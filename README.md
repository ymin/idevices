# idevices

A simple lib to get infomations of real devices and similators, with using [Libimobiledevice](http://brewformulas.org/Libimobiledevice)

# Install
```ruby
gem install idevices
```

# Usages
```ruby
require 'idevices'

```

Get device infos of given device udid 
```ruby
Idevices.device_info(device_udid)
```

Get all similators' infos
```ruby
Idevices.available_simulators
```

Get all connected real devices' infos
```ruby
Idevices.available_real_devices
```

# Contributing

Welcome to get your contributions, to help improving the lib.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License
This project is licensed under the terms of the MIT license.