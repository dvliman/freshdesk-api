require "rubygems"
require 'rest_client'
require 'nokogiri'

=begin
response = RestClient::Request.new(:method => :get, 
                                    :url => 'http://onescreen.freshdesk.com/contacts.xml', 
                                    :user => 'limanoit@gmail.com', 
                                    :password => '134658').execute
=end 
pay = 
  "<customer><name>testing</name></customer>"
  

url = 'http://onescreen.freshdesk.com/customers.xml'
user = 'limanoit@gmail.com'
password = '134658'

RestClient.add_before_execution_proc do | req, params |
  req.basic_auth 'limanoit@gmail.com', '134658'
end

customer =  Nokogiri::XML("<customer><name>Alf</name></customer>")
response = RestClient.post url, pay, :content_type => "text/xml"

puts response

class Freshdesk
   
  attr_accessor :url, :username, :password 
  
  def initialize(args)
     
  end
                                 
  def add_auth(username, password)
    @username, @password = username, password
  end 
   
end
