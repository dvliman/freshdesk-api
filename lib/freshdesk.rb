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
  
  # Freshdesk API client support "GET" with id parameter optional
  #   Examples: 
  #     client = Freshdesk.new(url, username, password)
  #     client.get_tickets     => list all the tickets
  #     client.get_tickets 123 => view a particular ticket with id 123
  #
  #   Returns nil if there is no response
  def self.define_get(name, *args)
    name = name.to_s
    method_name = "get_" + name

    define_method method_name do |args|
      uri = mapping(name)
      uri.gsub!(/.xml/, "/#{args}.xml") if !args.nil?
      
      begin
        response = RestClient.get uri
      rescue 
        response = nil
      end
    end
  end
  
  # Freshdesk API client support "DELETE" with the required id parameter
  #   Examples: 
  #     client = Freshdesk.new(url, username, password)
  #     client.delete_tickets 123 => delete a particular ticket with id 123
  #
  #  Will throw: 
  #    RestClientErrors if it can not find a particular id or 
  #                     if there is an error in connection
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
  
  # Freshdesk API client support "POST" with the required id parameter
  #   Examples: 
  #     client = Freshdesk.new(url, username, password)
  #     client.post_users :name=> "david", :customer => "google"
  #       => create a user with the name david and company name google
  #
  #  Will throw: 
  #    RestClientErrors  if the same object already exists or
  #                      server does not accept the parameter
  def self.define_post(name, *args)
    name = name.to_s
    method_name = "post_" + name
    
    define_method method_name do |args|
      raise StandardError, "Arguments are required to modify data" if args.nil?
      uri = mapping(name)
      
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.send(doc_name(name)) {
          args.each do |key, value|
            xml.send(key, value)
          end
        }
      end
      
      body = ""
      begin 
        response = RestClient.post uri, builder.to_xml, :content_type => "text/xml"
        body = response.to_s
      rescue RestClient::UnprocessableEntity => ex
        body = ex.response.to_s
      rescue Exception => e
        puts e.to_s
        raise
      end   
      
      #parse
      puts body      
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
      when "tickets" then File.join(@base_url + "helpdesk/tickets.xml")
      when "ticket_fields" then File.join( @base_url, "ticket_fields.xml")
      when "users" then File.join(@base_url, "contacts.xml")
      when "forums" then File.join(@base_url + "categories.xml")
      when "solutions" then File.join(@base_url + "solution/categories.xml")
      when "companies" then File.join(@base_url + "customers.xml")
    end
  end
  
  # match with the root name of xml document that freskdesk uses
  def doc_name(name)
    doc = case name 
      when "tickets" then "helpdesk_ticket"
      when "ticket_fields" then "helpdesk-ticket-fields"
      when "users" then "user"
      when "companies" then "customer"
      else raise StandardError, "No root object for this call"
    end
  end
end

freshdesk = Freshdesk.new('http://onescreen.freshdesk.com', 'limanoit@gmail.com', '134658')
response  = freshdesk.post_users(:name => 'test', :email => 'test@test.com', :customer => "onescreen")
