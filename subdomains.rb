require 'octokit'
require 'base64'
require 'yaml'

$client = Octokit::Client.new(:login => 'Orpheus', :password => 'OrpheusPass')
contents = $client.contents("hackclub/dns", :path => "hackclub.com.yaml")
$decoded_content = Base64.decode64(contents.content)

def append_subdomain(subdomain, host)
  new_content = YAML.load($decoded_content + subdomain + ":\n  ttl: 1\n  type: CNAME\n  value: " + host + ".")
  sorted = Hash[ new_content.sort_by { |key, val| key } ]
  update_file_on_github(subdomain, sorted.to_yaml)
end

def update_file_on_github(subdomain, content)
  blob_sha = "f40f8454ffdd0392f0610f8687a29a2c9cca2305"
  $client.update_contents("hackclub/dns", "hackclub.com.yaml", "add subdomain #{subdomain}", blob_sha, content)
end

# usage: append_subdomain("requested-subdomain", "where-its-hosted")
# append_subdomain("kewthljh", "wlcat.club")
