# GlitchyGem

To install go to http://glitchapp.com and create an account. Click edit profile and save your API Key. Create a file in you config/initializers directory called glitchy.rb and put this in it:

```ruby
GlitchyGem.configure do |config|
  config.api_key = "YOUR_API_KEY"
end
```

This gem will work with Rails 2.3.x and up
