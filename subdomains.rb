require 'octokit'
require 'dotenv/load'
require 'base64'

client = Octokit::Client.new(:login => 'orpheus', :password => 'orpheus-pass')
contents = client.contents("hackclub/dns", :path => "hackclub.com.yaml")
puts Base64.decode64(contents.content)
