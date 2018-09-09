require 'octokit'
require 'base64'
require 'yaml'

$client = Octokit::Client.new(:login => 'OrpheusUser', :password => 'OrpheusPass')
contents = $client.contents("hackclub/dns", :path => "hackclub.com.yaml")
$decoded_content = Base64.decode64(contents.content)

def append_subdomain(subdomain, host)
  new_content = $decoded_content + subdomain + ":\n  ttl: 1\n  type: CNAME\n  value: " + host + "."

  val_file = File.exist?("vals.yml") ? YAML.load_file("vals.yml") : File.new("vals.yml", "w")
  File.write("vals.yml", new_content)
  parsed_content = YAML.load_file("vals.yml")
  sorted = Hash[ parsed_content.sort_by { |key, val| key } ]
  File.write("vals.yml", sorted.to_yaml)

  update_file_on_github(subdomain, sorted.to_yaml)
end

def update_file_on_github(subdomain, content)
  blob_sha = "f40f8454ffdd0392f0610f8687a29a2c9cca2305"
  $client.update_contents("hackclub/dns", "hackclub.com.yaml", "add subdomain #{subdomain}", blob_sha, content)
end

# usage: append_subdomain("requested-subdomain", "where-its-hosted")
# append_subdomain("cegg2ge2e", "wlcat.club")
