require "rubygems"
require 'rest_client'
require 'pp'

=begin
response = RestClient::Request.new(:method => :get, 
                                    :url => 'http://onescreen.freshdesk.com/contacts.xml', 
                                    :user => 'limanoit@gmail.com', 
                                    :password => '134658').execute
=end 
pay = 
  "<customer><name>freshdesk</name></customer>"
  
response = RestClient::Request.new(:method => :post, 
                                    :url => 'http://onescreen.freshdesk.com/customers.xml', 
                                    :user => 'limanoit@gmail.com', 
                                    :password => '134658',
                                    :payload => pay, 
                                    :content_type => 'application/xml').execute
puts response


class Freshdesk
   
  attr_accessor :url, :username, :password 
                                 
  def add_auth(username, password)
    @username, @password = username, password
  end 
   
end
