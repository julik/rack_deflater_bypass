require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rack'
require 'rack/lobster'

describe "RackDeflaterBypass" do
  include Rack::Test::Methods
  
  def app
    tgz = lambda {|_| [200, {'Content-Type'=>'text/plain'}, ["Hello from .tgz"]]}
    
    Rack::Builder.new do | b |
      use RackDeflaterBypass
      
      b.map '/lobster' do
        run Rack::Lobster.new
      end
      
      b.map '/lobster.agz' do
        run Rack::Lobster.new
      end
      
      b.map '/geezip.tgz' do
        run tgz
      end
      
      b.map '/geezip.tar.gz' do
        run tgz
      end
    end.to_app
  end
  
  it 'allows Deflate to compress when Accept-Encoding is set to gzip' do
    get '/lobster', {}, {"HTTP_ACCEPT_ENCODING" => "gzip"}
    ref = {"Vary"=>"Accept-Encoding", "Content-Encoding"=>"gzip", "Content-Length"=>"288"}
    expect(last_response.headers).to eq(ref)
  end
  
  it 'allows Deflate to compress with hypothetical "agz" extension' do
    get '/lobster.agz', {}, {"HTTP_ACCEPT_ENCODING" => "gzip"}
    ref = {"Vary"=>"Accept-Encoding", "Content-Encoding"=>"gzip", "Content-Length"=>"288"}
    expect(last_response.headers).to eq(ref)
  end
  
  it 'bypasses Deflate when the request URI has .tgz extension' do
    get '/geezip.tgz', {}, {"HTTP_ACCEPT_ENCODING" => "gzip"}
    expect(last_response.headers['Vary']).to be_nil
    expect(last_response.headers['Content-Encoding']).to be_nil, 'Should have not set Content-Encoding'
    expect(last_response.body).to eq("Hello from .tgz"), 'Should have passed the body unencoded'
  end
  
  it 'bypasses Deflate when the request URI has .gz extension' do
    get '/geezip.tar.gz', {}, {"HTTP_ACCEPT_ENCODING" => "gzip"}
    expect(last_response.headers['Vary']).to be_nil
    expect(last_response.headers['Content-Encoding']).to be_nil, 'Should have not set Content-Encoding'
    expect(last_response.body).to eq("Hello from .tgz"), 'Should have passed the body unencoded'
  end
end
