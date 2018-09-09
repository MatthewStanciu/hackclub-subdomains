require 'octokit'
require 'dotenv/load'
require 'base64'

client = Octokit::Client.new(:login => 'MatthewStanciu', :password => '1c78cdff7b0397d528ef589357cafcfd20ad3d9c')
contents = client.contents("hackclub/dns", :path => "hackclub.com.yaml")
$decoded_content = Base64.decode64(contents.content)

def append_subdomain(subdomain, host)
  new_content = $decoded_content + subdomain + ":\n  ttl: 1\n  type: CNAME\n  value: " + host + "."

  puts new_content
end

append_subdomain("westlafayette", "https://wlcat.club")
