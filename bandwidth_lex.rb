# bandwidth_dialogflow.rb
#
# A sample application demonstration how to create a chatbot using Bandwidth and Amazon's Lex
#
# Take note that this is a sample application used to demonstrate functionality that Bandwidth provides.
#
# Author: Austin Bello
# Copyright Bandwidth INC

require 'rubygems'
require 'ruby-bandwidth'
require 'sinatra'
require "json"
require 'aws-sdk-lex'
require 'aws-sdk'

# Messaging Application using Amazon's Lex and Bandwidth

$BANDWIDTH_USER_ID = ENV['BANDWIDTH_USER_ID'] || raise(StandardError, "Environmental variable BANDWIDTH_USER_ID needs to be defined")
$BANDWIDTH_API_TOKEN = ENV['BANDWIDTH_API_TOKEN'] || raise(StandardError, "Environmental variable BANDWIDTH_API_TOKEN needs to be defined")
$BANDWIDTH_API_SECRET = ENV['BANDWIDTH_API_SECRET'] || raise(StandardError, "Environmental variable BANDWIDTH_API_SECRET needs to be defined")
$BANDWIDTH_APPLICATION_ID = ENV['BANDWIDTH_APPLICATION_ID'] || raise(StandardError, "Environmental variable BANDWIDTH_APPLICATION_ID needs to be defined")
$access_key_id = ENV["access_key_id"] || raise(StandardError, "Environmental variable access_key_id needs to be defined")
$secret_access_key = ENV["secret_access_key"] || raise(StandardError, "Environmental variable secret_access_key needs to be defined")
$region = ENV["region"] || raise(StandardError, "Environmental variable region needs to be defined")
$bot_name = ENV["bot_name"] || raise(StandardError, "Environmental variable bot_name needs to be defined")
$bot_alias = ENV["bot_alias"] || raise(StandardError, "Environmental variable bot_alias needs to be defined")

# detects intent from a piece of text, and returns the fullfillment text
def aws_lex_response(user_id, text)

    lex_client = Aws::Lex::Client.new(
        access_key_id: $access_key_id,
        secret_access_key: $secret_access_key,
        region: $region,
    )

    lex_response = lex_client.post_text({
        bot_name: $bot_name,
        bot_alias: $bot_alias,
        user_id: user_id,
        input_text: text,
      }
    )

    return lex_response["message"]

end

bandwidth_client = Bandwidth::Client.new(:user_id => $BANDWIDTH_USER_ID, :api_token => $BANDWIDTH_API_TOKEN, :api_secret => $BANDWIDTH_API_SECRET)

# handle messages events from Bandwidth
post '/messages' do
    status 204 # successful request with no body content

    request_payload = JSON.parse(request.body.read)[0]

    if request_payload["type"] == "message-received"
        message = Bandwidth::V2::Message.create(bandwidth_client, {
            :from => request_payload["to"],
            :to => [request_payload["message"]["from"]],
            # user_id allows your Amazon Lex application to know which conversation the incoming text is associated with
            # user_id will be the incoming phone number stripped of the "+"
            :text => aws_lex_response(request_payload["message"]["from"].tr('+', ''), request_payload["message"]["text"]),
            :application_id => $BANDWIDTH_APPLICATION_ID}
            )

        return "success"
    end
end
