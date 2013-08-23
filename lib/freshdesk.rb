require 'rest_client'
require 'nokogiri'
require 'uri'

class Freshdesk

  # custom errors
  class AlreadyExistedError < StandardError; end
  class ConnectionError < StandardError; end
  
  attr_accessor :base_url
  
  def initialize(base_url, username, password='X')
    
    @base_url = base_url
    
    RestClient.add_before_execution_proc do | req, params |
      req.basic_auth username, password
    end
  end

  def response_format
    @response_format ||= "xml"
  end

  # Specify the response format to use--JSON or XML. Currently JSON is only
  # supported for GETs, so other verbs will still use XML.
  def response_format=(format)
    unless format.downcase =~ /json|xml/
      raise StandardError "Unsupported format: '#{format}'. Please specify 'xml' or 'json'."
    end
    @response_format = format.downcase
  end
  
  # Freshdesk API client support "GET" with id parameter optional
  #   Returns nil if there is no response
  def self.fd_define_get(name)
    name = name.to_s
    method_name = "get_" + name

    define_method method_name do |*args| 
      uri = mapping(name)
      uri.gsub!(/\.xml/, "\.#{response_format}") 
      uri.gsub!(/\.#{response_format}/, "/#{args}\.#{response_format}") if args.size > 0

      begin
        response = RestClient.get uri
      rescue Exception
        response = nil
      end
    end
  end

  # Certain GET calls require query strings instead of a more
  # RESTful URI. This method and fd_define_get are mutually exclusive.
  def self.fd_define_parameterized_get(name)
    name = name.to_s
    method_name = "get_" + name

    define_method method_name do |params={}| 
      uri = mapping(name)
      uri.gsub!(/\.xml/, ".#{response_format}") 
      unless params.empty?
        uri += '?' + URI.encode_www_form(params)
      end

      begin
        response = RestClient.get uri
      rescue Exception
        response = nil
      end
    end
  end
  
  # Freshdesk API client support "DELETE" with the required id parameter
  def self.fd_define_delete(name)
    name = name.to_s
    method_name = "delete_" + name

    define_method method_name do |args|
      uri = mapping(name)
      raise StandardError, "An ID is required to delete" if args.size.eql? 0
      uri.gsub!(/.xml/, "/#{args}.xml")
      RestClient.delete uri
    end
  end
  
  # Freshdesk API client support "POST" with the optional key, value parameter
  #
  #  Will throw: 
  #    AlreadyExistedError if there is exact copy of data in the server
  #    ConnectionError     if there is connection problem with the server
  def self.fd_define_post(name)
    name = name.to_s
    method_name = "post_" + name
    
    define_method method_name do |args|
      raise StandardError, "Arguments are required to modify data" if args.size.eql? 0
      uri = mapping(name)
      
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.send(doc_name(name)) {
          if args.has_key? :attachment
            attachment_name = args[:attachment][:name] or raise StandardError, "Attachment name required"
            attachment_cdata = args[:attachment][:cdata] or raise StandardError, "Attachment CDATA required" 
            xml.send("attachments", type: "array") {
              xml.send("attachment") {
                xml.send("resource", "type" => "file", "name" => attachment_name, "content-type" => "application/octet-stream") {
                  xml.cdata attachment_cdata
                }
              }
            }
          args.except! :attachment
          end
          args.each do |key, value|
            xml.send(key, value)
          end
        }
      end

      begin 
        response = RestClient.post uri, builder.to_xml, :content_type => "text/xml"
        
      rescue RestClient::UnprocessableEntity
        raise AlreadyExistedError, "Entry already existed"
      
      rescue RestClient::InternalServerError
        raise ConnectionError, "Connection to the server failed. Please check hostname"
      
      rescue RestClient::Found
        raise ConnectionError, "Connection to the server failed. Please check username/password"
      
      rescue Exception
        raise
      end   
      
      response   
    end
  end

  # Freshdesk API client support "PUT" with key, value parameter
  #
  #  Will throw: 
  #    ConnectionError     if there is connection problem with the server
  def self.fd_define_put(name)
    name = name.to_s
    method_name = "put_" + name
    
    define_method method_name do |args|
      raise StandardError, "Arguments are required to modify data" if args.size.eql? 0
      raise StandardError, "id is required to modify data" if args[:id].nil?
      uri = mapping(name)
      
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.send(doc_name(name)) {
          args.each do |key, value|
            xml.send(key, value)
          end
        }
      end

      begin 
        uri.gsub!(/.xml/, "/#{args[:id]}.xml")
        response = RestClient.put uri, builder.to_xml, :content_type => "text/xml"
        
      rescue RestClient::InternalServerError
        raise ConnectionError, "Connection to the server failed. Please check hostname"
      
      rescue RestClient::Found
        raise ConnectionError, "Connection to the server failed. Please check username/password"
      
      rescue Exception
        raise
      end   
      
      response   
    end
  end
  
  [:tickets, :ticket_fields, :users, :forums, :solutions, :companies].each do |a|
    fd_define_get a
    fd_define_post a  
    fd_define_delete a
    fd_define_put a
  end

  [:user_ticket].each do |resource|
    fd_define_parameterized_get resource
  end
  
   
  # Mapping of object name to url:
  #   tickets => helpdesk/tickets.xml
  #   ticket_fields => /ticket_fields.xml
  #   users => /contacts.xml
  #   forums => /categories.xml
  #   solutions => /solution/categories.xml
  #   companies => /customers.xml
  def mapping(method_name)
    case method_name
      when "tickets" then File.join(@base_url + "helpdesk/tickets.xml")
      when "user_ticket" then File.join(@base_url + "helpdesk/tickets/user_ticket.xml")
      when "ticket_fields" then File.join( @base_url, "ticket_fields.xml")
      when "users" then File.join(@base_url, "contacts.xml")
      when "forums" then File.join(@base_url + "categories.xml")
      when "solutions" then File.join(@base_url + "solution/categories.xml")
      when "companies" then File.join(@base_url + "customers.xml")
    end
  end
  
  # match with the root name of xml document that freskdesk uses
  def doc_name(name)
    case name 
      when "tickets" then "helpdesk_ticket"
      when "ticket_fields" then "helpdesk-ticket-fields"
      when "users" then "user"
      when "companies" then "customer"
      else raise StandardError, "No root object for this call"
    end
  end
end
