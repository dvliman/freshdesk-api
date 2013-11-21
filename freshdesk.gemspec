# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'freshdesk'
  s.version     = "0.4"
  s.date        = '2014-02-14'
  s.summary     = "Ruby Gem for interfacing with the Freshdesk API"
  s.description = "Ruby Gem for interfacing with the Freshdesk API"
  s.authors     = ["David Liman", "Tim Macdonald", "Jesse Pinho"]
  s.email       = 'limanoit@gmail.com'
  s.files       = ["lib/freshdesk.rb"]
  s.homepage    = 'https://github.com/dvliman/freshdesk-api'
  s.add_runtime_dependency 'rest-client'
  s.add_runtime_dependency 'nokogiri'
end
