trade.gov Industry Mapper
==============

### Ruby

You'll need [Ruby 2.1](http://www.ruby-lang.org/en/downloads/) and Rails 4.

### Gems

We use bundler to manage gems. You can install bundler and other required gems like this:

    gem install bundler
    bundle install

### MySQL

Follow the instructions in config/database.yml, then set up your development/test databases and populate them with seed data:

    rake db:setup
    RAILS_ENV=test rake db:setup

To create an admin user, use the rails console:

    $ rails c
    > AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')

### Running it

Fire up a server and try it all out.

    bundle exec rails s

Visit `http://localhost:3000/admin` and log in as the default user:

* __User__: admin@example.com
* __Password__: password

From there, you can see the industries and the sectors each one contains, and for each sector you can see the eMenu industry sectors it encapsulates.

Now try a lookup:

<http://localhost:3000/api/industries.json?topic=Artwork&source=MarketResearch>

### Tests

    bundle exec rake

### Code Coverage

We track test coverage of the codebase over time, to help identify areas where we could write better tests and to see when poorly tested code got introduced.

After running your tests, view the report by opening `coverage/index.html`.

Click around on the files that have < 100% coverage to see what lines weren't exercised.
