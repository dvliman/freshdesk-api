# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'freshdesk'
  s.version     = "0.1"
  s.date        = '2012-02-22'
  s.summary     = "Ruby Gem for interfacing with the Freshdesk API"
  s.description = "Ruby Gem for interfacing with the Freshdesk API"
  s.authors     = ["David Liman"]
  s.email       = 'limanoit@gmail.com'
  s.files       = ["lib/freshdesk.rb"]
  s.homepage    = 'https://github.com/dvliman/freshdesk-api'
  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'nokogiri'
end
