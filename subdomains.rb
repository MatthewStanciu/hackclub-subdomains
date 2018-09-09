require 'octokit'
require 'base64'
require 'yaml'

$client = Octokit::Client.new(:login => 'Orpheus', :password => 'OrpheusPassword')
contents = $client.contents("hackclub/dns", :path => "hackclub.com.yaml")
$decoded_content = Base64.decode64(contents.content)
$blob_sha = contents.sha

def append_subdomain(subdomain, host)
  message = ""
  new_content = YAML.load($decoded_content + subdomain + ":\n  ttl: 1\n  type: CNAME\n  value: " + host + ".")
  sorted = Hash[ new_content.sort_by { |key, val| key } ]

  if $decoded_content[subdomain] != nil
    message = "update subdomain #{subdomain}"
  else
    message = "add subdomain #{subdomain}"
  end
  update_file_on_github(subdomain, sorted.to_yaml, message)
end

def update_file_on_github(subdomain, content, message)
  $client.update_contents("hackclub/dns", "hackclub.com.yaml", message, $blob_sha, content)
end

# usage: append_subdomain("requested-subdomain", "where-its-hosted")
# append_subdomain("westlafayette", "wlcat.club")
