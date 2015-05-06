# Wrapper for Rack::Deflater that will prevent
# the said Deflater from EVER touching .tgz files
class RackDeflaterBypass
  VERSION = '0.0.1'
  BYPASS_FILES = /\.(t?)gz$/

  # bypass_url_regexp will be matched against PATH_INFO
  def initialize(app, bypass_url_regexp = BYPASS_FILES)
    @bypass_url_regexp = bypass_url_regexp
    @app = app
    @deflater = Rack::Deflater.new(@app)
  end
  
  def call(env)
    if env['PATH_INFO'] =~ @bypass_url_regexp
      @app.call(env)
    else
      @deflater.call(env)
    end
  end
end