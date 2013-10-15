= Kaminari Cache

Kaminari Cache makes caching your Kaminari pagination a breeze.

=== Currently supported:
* RedisStore for Redis
* DalliStore for Memcached
  * Note that you will need the dalli-store-extensions gem because kaminari-cache makes use of the `delete_matched` method which is not in dalli gem

== Usage

In your controller, simply call `Model.fetch_page` (instead of `Model.page`) with an options hash containing `:page, :per & :order`.

`:order` can be a Symbol, a Hash or a String depending on your sorting needs.

Example:

In your controller:
```ruby
  @events = Event.fetch_page :page => (params[:page] || 1),
                   :per => 18,
                   :order => {
                     :start => :desc,
                     :updated_at => :desc
                   }
```

In your view:
```ruby
  @events.entries.each do |entry|
    # Do your thing
  end
```

== TODO

* Testing!
* More cache engines!

== Contributing to kaminari-cache
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2013 Jim. See LICENSE.txt for
further details.

