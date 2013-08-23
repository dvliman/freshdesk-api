## freshdesk-api ##
A Ruby API client that interfaces with freshdesk.com web service. This client supports regular CRUD operation 

Freshdesk's API docs are here [http://freshdesk.com/api/](http://freshdesk.com/api/)

As of now, it supports the following: 

  - tickets
  - users
  - forums
  - solutions
  - companies

## Usage Example ##

```
client = Freshdesk.new("http://companyname.freshdesk.com/", "user@domain.com", "password")  
# note trailing slash in domain is required

response = client.get_users  
client.get_users 123  
client.post_users(:name => "test", :email => "test@143124test.com", :customer => "name")  
client.put_users(:id =>123, :name => "test", :email => "test@143124test.com", :customer => "name")  
client.delete_tickets 123  

# example of working with users
users = REXML::Document.new(client.get_users)
users.elements.each("users/user") { |u|
			puts u.elements['email'].text
			puts u.elements['id'].text
		}

```

## GET request ##

```
client.get_tickets(id - optional)
client.get_user_ticket({:email => 'foo@example.com})
client.get_users(id - optional)
client.get_forums(id - optional)
client.get_solutions(id - optional)
client.get_companies(id - optional)
```

## POST request ##

```
client.post_users(key1 => value, key2 => value2, ...)

# example posts a ticket
client.post_tickets(:email => "user@domain.com", :description => "test ticket from rails app", :name => "Customer Name", :source => 2, :priority => 2, :name => "Joshua Siler")
# etc.
```

## DELETE request ##

```
client.delete_users(id - required)
# etc.
```

## Authors ##
- @dvliman
- @tsmacdonald




