# lib/nginx_server.rb
#
# 

class N
  attr_accessor :prefix, :opt, :suffix
  def initialize(*params)
    # Check for subdomain parameter
    @name = params[0]
    if @name =~ /^\.(.*)$/
      @sd = true
      @name = $1
    end

    # Sensible defaults.
    @root     = "/var/www/#{@name}"
    @root_pub = "#{@root}/public"
    @log      = "#{@root}/log"
    # Explicit root/log specified.
    if params.length == 2 && params[1] == :localhost
      @root =     '/var/www/localhost'
      @root_pub = "#{@root}/public"
      @log =      "#{@root}/log"
    elsif params.length == 2
      @root = params[1]
      @root_pub = @root
      @log = '/var/www/localhost/log'
    elsif params.length == 3
      params[1] = '/var/www/localhost/public' if params[1] == :localhost
      params[2] = '/var/www/localhost/log' if params[2] == :localhost
      @root = params[1]
      @root_pub = @root
      @log = params[2]
    end

    # Find absolute request by removing /var/www.
    @rel_root_pub = @root_pub.gsub('/var/www/', '')

    # Capture @prefix and @opt
    $server = self
    @prefix = ""
    @opt = ""
    @suffix = ""

    # Grab additional parts from options_core.rb
    yield if block_given?
  end

  def to_s
    # Generate text.
    #   See: <http://wiki.codemongers.com/NginxHttpRewriteModule>
    #   See: <http://en.wikipedia.org/wiki/URL_normalization>
    # Permanent rewrites URL on client. Last rewrites on server.
    tbr = @prefix + <<-eos
server {
  set $name         #{@name};
  set $root         #{@root};
  set $root_pub     #{@root_pub};
  set $rel_root_pub #{@rel_root_pub};

  listen 80;
  server_name   #{@sd ? '.' : ''}#{@name};
  access_log    #{@log}/access.log;
  error_log     #{@log}/error.log info;

  if ($host ~* ^www\.(.*)) {
    set $host_without_www $1;
    rewrite ^(.*)$ http://$host_without_www$1 permanent;
  }
    eos

    if @sd; tbr += "\n" + <<-eos
  if ($host ~ ^(.*?)\.?#{@name}) {
    set $subdomain $1;
  }
    eos
    end

    tbr += "\n" + @opt + <<-eos
  root          $root_pub/$subdomain/;
  index         index.php index.html index.htm home.php home.html home.htm main.php main.html main.htm;
}
    eos
  end

  def >(file)
    fout = File.new(file, 'w')
    fout.puts self
    fout.close
  end

  def >>(file)
    fout = File.new(file, 'a')
    fout.puts self
    fout.close
  end
end

def redir(from, to) 
  N.new(from, :localhost) { redirect(to) }
end
