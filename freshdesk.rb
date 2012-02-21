require "rubygems"
require 'rest_client'
require 'nokogiri'

# Mappings of object name to url:
#   tickets => helpdesk/tickets.xml
#   ticket_fields => /ticket_fields.xml
#   users => /contacts.xml
#   forums => /categories.xml
#   solutions => /solution/categories.xml
#   companies => /customers.xml
class Freshdesk
   
  attr_accessor :base_url, :username, :password 
  
  def initialize(base_url, username, password)
    
    @base_url = base_url
    
    RestClient.add_before_execution_proc do | req, params |
      req.basic_auth username, password
    end
  end

  def create_user(args)
    raise ArgumentError if !args.is_a?(Hash)
    
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.user {
        args.each do |key, value|
          xml.send(key, value)
        end
      }
    end
    
    begin
      RestClient.post @base_url + '/contacts.xml',  builder.to_xml, :content_type => "text/xml"
    rescue  RestClient::UnprocessableEntity => e
      raise StandardError, "User with the same name already exists"
    end
  end
  
  def create_company(args)
    raise ArgumentError if !args.is_a?(Hash)
    
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.customer {
        args.each do |key, value|
          xml.send(key, value)
        end
      }
    end
    
    begin
      RestClient.post @base_url + '/customers.xml',  builder.to_xml, :content_type => "text/xml"
    rescue  RestClient::UnprocessableEntity => e
      raise StandardError, "Company with the same name already exists"
    end
  end
end

client = Freshdesk.new('http://onescreen.freshdesk.com', 'limanoit@gmail.com', '134658')
client.create_company({:name => "company2", :email => "my company description" })
