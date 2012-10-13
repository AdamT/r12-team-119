# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# Setup Rack
if Rails.env.development?
  # Hack broken file join in rack-dir
  class MyDirectory < Rack::Directory
    def list_directory
      @files = [['../','Parent Directory','','','']]
      glob = F.join(@path, '*')

      Dir[glob].sort.each do |node|
        stat = stat(node)
        next  unless stat
        basename = F.basename(node)
        ext = F.extname(node)

        url = F.join(@script_name, @path_info, basename)
        size = stat.size
        type = stat.directory? ? 'directory' : Rack::Mime.mime_type(ext)
        size = stat.directory? ? '-' : filesize_format(size)
        mtime = stat.mtime.httpdate
        url << '/'  if stat.directory?
        basename << '/'  if stat.directory?

        @files << [ url, basename, size, type, mtime ]
      end

      return [ 200, {'Content-Type'=>'text/html; charset=utf-8'}, self ]
    end
  end
  run Rack::URLMap.new( {
    "/mail"    => MyDirectory.new( "tmp/letter_opener" ), # Serve our static content
    "/" => DtimeRumble::Application
  } )
else
  run DtimeRumble::Application
end
