# Kaminari Cache

**This gem is no longer maintained, and [I wouldn’t even recommend you use it](https://github.com/jdurand/kaminari-cache/issues/1)!**

----------------------------------------------------------------

Kaminari Cache makes caching your Kaminari pagination a breeze

### Currently supported:
* RedisStore for Redis
* DalliStore for Memcached
  * Note that you will need the dalli-store-extensions gem because kaminari-cache makes use of the `delete_matched` method which is not in dalli gem

When using an unsupported cache engine, the entire cache will be flushed when editing a record.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kaminari-cache'
```

## Usage

In your controller, simply call `Model.fetch_page` (instead of `Model.page`) with an options hash containing `:page`, `:per` & `:order`.

`:order` can be a Symbol, a Hash or a String depending on your sorting needs.

#### Example:

In your controller:
```ruby
  @events = Event.fetch_page :page => (params[:page] || 1),
                   :per => 18,
                   :order => {
                     :start => :desc,
                     :updated_at => :desc
                   }
                   # :locale => :fr,
                   # :scope => :latest,
                   # :includes => :occurrences
```

In your view:
```ruby
  @events.each do |entry|
    # Do your thing
  end
```

**Note** that `fetch_page` returns an array of type `Kaminari::PaginatableArray` so if you use something like *Draper* which decorates *ActiveRecord* collections, you'll need to decorate them manualy and delegate the needed methods:

In an initializer (config/initializers/draper.rb):
```ruby
  Draper::CollectionDecorator.delegate :current_page, :total_pages, :limit_value, :total_count
```

In your controller:
```ruby
  @events = Draper::CollectionDecorator.new Event.fetch_page(...)
```

## TODO

* Testing!
* More cache engines

## Contributing to Kaminari Cache
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright © 2013-2014 [Jim Durand](http://twitter.com/durandjim "Twitter"). See [LICENSE.txt](http://github.com/jdurand/kaminari-cache/blob/master/LICENSE.txt "LICENSE") for
further details.

