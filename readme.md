## freshdesk-api ##
A Ruby API client that interfaces with freshdesk.com web service. This client supports regular CRUD operation 

As of now, it supports the following: 

  - tickets
  - users
  - forums
  - solutions
  - companies

## Usage Example ##

```
client = Freshdesk.new("http://companyname.freshdesk.com", "user@domain.com", "password")  
response = client.get_users  
client.get_users 123  
client.post_users(:name => "test", :email => "test@143124test.com", :customer => "name")  
client.put_users(:id =>123, :name => "test", :email => "test@143124test.com", :customer => "name")  
client.delete_tickets 123  
```

## GET request ##

```
get_tickets (id - optional)
get_users (id - optional)
get_forums (id - optional)
get_solutions (id - optional)
get_companies (id - optional)
```

## POST request ##

```
get_users (key1 => value, key2 => value2, ...)
```

## DELETE request ##

```
delete_users (id - required)
```

## Author ##
@dvliman




