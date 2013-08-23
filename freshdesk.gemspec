# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'freshdesk'
  s.version     = "0.3"
  s.date        = '2013-08-23'
  s.summary     = "Ruby Gem for interfacing with the Freshdesk API"
  s.description = "Ruby Gem for interfacing with the Freshdesk API"
  s.authors     = ["David Liman", "Tim Macdonald"]
  s.email       = 'tsmacdonald@gmail.com'
  s.files       = ["lib/freshdesk.rb"]
  s.homepage    = 'https://github.com/tsmacdonald/freshdesk-api'
  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'nokogiri'
end
