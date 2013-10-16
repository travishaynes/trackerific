Trackerific.configure do |config|
  config.fedex = { account: 'account', meter: '123456789' }
  config.ups = { key: 'key', user_id: 'userid', password: 'secret' }
  config.usps = { user_id: 'userid', use_city_state_lookup: true }
  config.test = { user: 'test' }
  config.another_test_service = { user: 'another test' }
end
