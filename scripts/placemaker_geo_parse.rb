#!/usr/bin/env ../digitalnz/script/runner
require 'placemaker'

YOUR_APP_ID = 'YOUR_YAHOO_KEY'

 p = Placemaker::Client.new(:appid => YOUR_APP_ID, :document_url => 'http://feeds.feedburner.com/wooster', :document_type => 'text/xml')
 p.fetch!
 
 puts p.to_yaml
