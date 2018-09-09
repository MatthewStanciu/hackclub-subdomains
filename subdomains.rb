require 'octokit'
require 'base64'
require 'yaml'

$client = Octokit::Client.new(:login => 'MatthewStanciu', :password => 'my-password')
contents = $client.contents("MatthewStanciu/test-yml", :path => "domains.yml")
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
  blob_sha = "929696e489010e0bd421af4f6a0aba2bbf486c06"

  $client.update_contents("MatthewStanciu/test-yml", "domains.yml", "add subdomain #{subdomain}", blob_sha, content)
end

append_subdomain("cegg2ge2e", "wlcat.club")
#append_subdomain("kekehehe", "wlcat.club")
