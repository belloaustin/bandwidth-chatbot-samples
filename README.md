# Bandwidth Chatbot Samples
Bandwidth Messaging applications using Google Dialogflow and Amazon Lex.

<a href="http://dev.bandwidth.com"><img src="https://s3.amazonaws.com/bwdemos/BW_Messaging.png"/></a>

## How It Works
When an incoming message is received by a Bandwidth number, a notification will be sent to your application via a callback/webhook. Your application can then take the text from the body of that message and communicate with the NLU API of your choice to have a response created. From there, your application would take that response and send it in a message back to your customer.

## Google Dialogflow Setup
Follow the steps <a href="https://dialogflow.com/docs/getting-started" target="_blank">here</a> to create a Google Dialogflow agent. If you don't want to build an agent from scratch, take advantage of the pre-built demo agents Google Dialogflow provides.

Also, follow the steps <a href="https://cloud.google.com/docs/authentication/getting-started" target="_blank">here</a> to download your Google Application Credentials and set an environment variable directing to its location.

## Amazon Lex Setup
Sign into your AWS console and <a href="https://console.aws.amazon.com/lex/home?region=us-east-1#bot-create:" target="_blank">create</a> an Amazon Lex bot. You will also need to <a href="https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html" target="_blank">create a user</a> with an <a href="https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html" target="_blank">access key</a> for authentication.

## Web Server using ngrok
Set up a basic Sinatra server for Bandwidth to send incoming message callbacks to. For this demo, you can simply use ngrok to expose your local development environment to the Internet. <a href="https://ngrok.com/download" target="_blank">ngrok</a> is free, and can be downloaded on all major operating systems. 

Once ngrok is downloaded, run ./ngrok http 4567 on the command line to open up a web server on Sinatra's default port of 4567. You should then see a screen with several pieces of information regarding your session. Take the `Forwarding` url that is secure (ex. https://some-letters-and-letters.ngrok.io) and hang onto it for later.

## Create a Bandwidth Application
Follow the instructions <a href="https://dev.bandwidth.com/v2-messaging/applications/about.html" target="_blank">here</a> to create a Bandwidth Application and assign that application a Bandwith phone number. You can place the url for your ngrok server as the `Callback Url` for the application.

## Environment Variables
Before running the project, the following environmental variables need to be set:

```
BANDWIDTH_USER_ID
BANDWIDTH_API_TOKEN
BANDWIDTH_API_SECRET
BANDWIDTH_APPLICATION_ID
```

These variables can all be found in your account at <a href="https://dashboard.bandwidth.com" target="_blank">https://dashboard.bandwidth.com</a>.

#### Google Dialogflow
```
GOOGLE_PROJECT_ID
```

This is the Project ID of your Google Dialogflow agent.

#### Amazon Lex
```
access_key_id
secret_access_key
```

Follow the steps above to create a IAM User with an access key and secret access key.

```
region
```

Use the name of the region under the `Region` column <a href="https://docs.aws.amazon.com/general/latest/gr/rande.html#lex_region" target="_blank">here</a>.

```
bot_name
bot_alias
```

Under `Settings` in your Amazon Lex console, `bot_name` can be found within the `General` tab and `bot_alias` can be found within the `Aliases` tab.

## Setup

Required dependencies can be installed by running the following command:

```
bundle install
```

To start the server, run the following command

```
ruby bandwdith_dialogflow.rb or ruby bandwdith_lex.rb
```

Once running, text the Bandwidth phone number associated with your application to begin communicating with your chatbot.
