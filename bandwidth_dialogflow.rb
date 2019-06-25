# bandwidth_dialogflow.rb
#
# A sample application demonstration how to create a chatbot using Bandwidth and Google Dialogflow
#
# Take note that this is a sample application used to demonstrate functionality that Bandwidth provides.
#
# Author: Austin Bello
# Copyright Bandwidth INC


require 'rubygems'
require 'ruby-bandwidth'
require "google/cloud/dialogflow"
require 'sinatra'
require "json"

# Messaging Application using Google's Dialogflow and Bandwidth

$BANDWIDTH_USER_ID = ENV['BANDWIDTH_USER_ID'] || raise(StandardError, "Environmental variable BANDWIDTH_USER_ID needs to be defined")
$BANDWIDTH_API_TOKEN = ENV['BANDWIDTH_API_TOKEN'] || raise(StandardError, "Environmental variable BANDWIDTH_API_TOKEN needs to be defined")
$BANDWIDTH_API_SECRET = ENV['BANDWIDTH_API_SECRET'] || raise(StandardError, "Environmental variable BANDWIDTH_API_SECRET needs to be defined")
$BANDWIDTH_APPLICATION_ID = ENV['BANDWIDTH_APPLICATION_ID'] || raise(StandardError, "Environmental variable BANDWIDTH_APPLICATION_ID needs to be defined")
$project_id = ENV["GOOGLE_CLOUD_PROJECT"] || raise(StandardError, "Environmental variable GOOGLE_CLOUD_PROJECT needs to be defined")

# detects intent from a piece of text, and returns the fullfillment text
def detect_intent_text(project_id, session_id, text, language_code)

    session_client = Google::Cloud::Dialogflow::Sessions.new
    session = session_client.class.session_path project_id, session_id

    query_input = { text: { text: text, language_code: language_code } }
    response = session_client.detect_intent session, query_input
    query_result = response.query_result

    return query_result.fulfillment_text

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
            # session_id allows your Google Dialogflow application to know which conversation the incoming text is associated with
            # session_id will be the incoming phone number
            :text => detect_intent_text($project_id, request_payload["message"]["from"], request_payload["message"]["text"], "en-US"),
            :application_id => $BANDWIDTH_APPLICATION_ID}
            )

        return "success"
    end
end
