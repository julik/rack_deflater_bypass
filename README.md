# rack_deflater_bypass

Ensures that if you send a .gz file from your Rack stack `Rack::Deflate` will not try to recompress
it and damage the headers in a way that confuses old browsers.

To use, just add it to your Rack stack __instead of Rack::Deflate__

    # config.ru
    use RackDeflaterBypass 

## Contributing to rack_deflater_bypass
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2015 Julik Tarkhanov. See LICENSE.txt for
further details.

