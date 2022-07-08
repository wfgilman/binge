# Binge
API supporting iOS app Binge: https://github.com/wfgilman/Binge-iOS

### Description
RESTful JSON webservice featuring:
- SMS based authentication using JSON webtoken
- PostgreSQL database
- Erlang Term Store (ETS) cache to quickly identify matches during swiping
- Automatic expiry of liked dishes from cache
- AWS S3 hosting of over 1,500 dishes across 80 restaurants
- iOS Push notifications on dish or restaurant match when perusing with friend

### Data
- Manually curated catalog of menu items images and restaurant metadata for Redwood City, CA
- CSV of restaurant metadata parsed and seeded into database table
- CSV of concatenated restaurant and menu item (dish) name parsed, seeded and keyed to restaurant
- User created account profile via mobile app
- User-friend records
- Many-to-many user-friend dish matches

### Credits
- Web server using [Phoenix 1.6](https://github.com/phoenixframework/phoenix)
- iOS Push Notifications by [Pigeon](https://github.com/codedge-llc/pigeon)
- Webtoken Authentication by [Guardian 2.0](https://github.com/ueberauth/guardian)
- SMS Messaging with Twilio and [API bindings](https://github.com/danielberkompas/ex_twilio)
- Application Performance Monitoring by [AppSignal](https://appsignal.com)
- Elixir/Erlange Releases using [Distillery](https://github.com/bitwalker/distillery)
- Hosting and deployment using [Gigalixir](https://gigalixir.com/)
