require 'sinatra'
require 'rest-client'
require 'json'
require 'slack-notifier'

get '/' do
  "This is a thing"
end

post '/' do
  # Verify all environment variables are set
  return [403, "No slack token setup"] unless slack_token = ENV['SLACK_TOKEN']
  return [403, "No jenkins url setup"] unless jenkins_url= ENV['JENKINS_URL']
  return [403, "No jenkins token setup"] unless jenkins_token= ENV['JENKINS_TOKEN']

  # Verify slack token matches environment variable
  return [401, "No authorized for this command"] unless slack_token == params['token']

  # Split command text
  job = params['text']
  build_url = "#{jenkins_url}/buildByToken/build?job=#{job}&token=#{jenkins_token}"

  # Make jenkins request
  resp = RestClient.post URI.escape(build_url), {}
end
