App contains:

+ EventMachine (https://github.com/eventmachine/eventmachine)
+ em-synchrony (https://github.com/igrigorik/em-synchrony)
+ faye-websocket (https://github.com/faye/faye-websocket-ruby)
+ opal (https://github.com/opal/opal)
+ opal-browser (https://github.com/opal/opal-browser)
+ opal-jquery (https://github.com/opal/opal-jquery)
+ activerecord

This app is a full-stack web application written completely on ruby. It uses opal for building client-side code. Communication goes through websockets. Backend is based on EM + asynchronous activerecord.

Usage

``` bash
$ bundle install
$ rake db:create db:migrate
$ rackup config.ru -s thin -E production
```
