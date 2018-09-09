require 'octokit'
require 'dotenv/load'
require 'base64'
require 'yaml'
require 'active_support'

client = Octokit::Client.new(:login => 'MatthewStanciu', :password => 'my-password')
contents = client.contents("hackclub/dns", :path => "hackclub.com.yaml")
$decoded_content = Base64.decode64(contents.content)

def returning(value)
  yield(value)
  value
end

#hash = YAML.load_file("test.yml")
#hash1 = Hash[ hash.sort_by { |key, val| key } ]
#puts hash1
#puts sort_yaml_file(thing.inspect)

def append_subdomain(subdomain, host)
  new_content = $decoded_content + subdomain + ":\n  ttl: 1\n  type: CNAME\n  value: " + host + "."
  val_file = File.exist?("vals.yml") ? YAML.load_file("vals.yml") : File.new("vals.yml", "w")
  File.write("vals.yml", new_content)
  parsed_content = YAML.load_file("vals.yml")
  sorted = Hash[ parsed_content.sort_by { |key, val| key } ]
  File.write("vals.yml", sorted.to_yaml)
end

append_subdomain("cegg2ge2e", "wlcat.club")
append_subdomain("kekehehe", "wlcat.club")
