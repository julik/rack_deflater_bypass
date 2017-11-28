# Do not use this

To make sure Rack::Deflate does not touch your output, either add `no-transform` to your
`Cache-Control` response header or set `Content-Encoding` to `identity`. Rack::Deflate
will then disengage.
