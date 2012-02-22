require 'rubygems'
require 'rest_client'
require 'nokogiri'


class Freshdesk
   
  attr_accessor :base_url
  
  def initialize(base_url, username, password)
    
    @base_url = base_url
    
    RestClient.add_before_execution_proc do | req, params |
      req.basic_auth username, password
    end
  end

=begin
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
=end
  
  # Freshdesk API client support "GET" with id parameter optional
  #   Examples: 
  #     client = Freshdesk.new(url, username, password)
  #     client.get_tickets     => list all the tickets
  #     client.get_tickets 123 => view a particular ticket with id 123
  #
  #  Will throw: 
  #   "RestClient::ResourceNotFound if it can not find a particular id or 
  #                                 if connection can not be established
  def self.define_get(name, *args)
    name = name.to_s
    method_name = "get_" + name

    define_method method_name do |args|
      uri = mapping(name)
      uri.gsub!(/.xml/, "/#{args}.xml") if !args.nil?
      response = RestClient.get uri
      response
    end
  end
  
  # Freshdesk API client support "DELETE" with the required id parameter
  #   Examples: 
  #     client = Freshdesk.new(url, username, password)
  #     client.delete_tickets 123 => delete a particular ticket with id 123
  #
  #  Will throw: 
  #   "RestClient::ResourceNotFound if it can not find a particular id or 
  #                                 if connection can not be established
  def self.define_delete(name, *args)
    name = name.to_s
    method_name = "delete_" + name

    define_method method_name do |args|
      uri = mapping(name)
      raise StandardError, "An ID is required to delete" if args.nil?
      uri.gsub!(/.xml/, "/#{args}.xml")
      RestClient.delete uri
    end
  end
  
  def self.define_post(name, *args)
    name = name.to_s
    method_name = "post_" + name
    define_method method_name do |args|
      raise StandardError, "An ID is required to modify data" if args.nil?
      puts args.class
      uri = mapping(name)
    
    end
  end
  
  [:tickets, :ticket_fields, :users, :forums, :solutions, :companies].each do |a|
    define_get a
    define_post a
    define_delete a
  end
    
  # Mapping of object name to url:
  #   tickets => helpdesk/tickets.xml
  #   ticket_fields => /ticket_fields.xml
  #   users => /contacts.xml
  #   forums => /categories.xml
  #   solutions => /solution/categories.xml
  #   companies => /customers.xml
  def mapping(method_name)
    path = case method_name
      when "tickets" then @base_url + "/helpdesk/tickets.xml"
      when "ticket_fields" then @base_url + "/ticket_fields.xml"
      when "users" then @base_url + "/contacts.xml"
      when "forums" then @base_url + "/categories.xml"
      when "solutions" then @base_url + "/solution/categories.xml"
      when "companies" then @base_url + "/customers.xml"
    end
  end
end

client = Freshdesk.new('http://onescreen.freshdesk.com', 'limanoit@gmail.com', '134658')
#client.create_company({:name => "cotempany2", :email => "my company description" })
#client.post_companies( {:name => "cotempany2", :email => "my company description" }, "david")
client.get_companies("33956")