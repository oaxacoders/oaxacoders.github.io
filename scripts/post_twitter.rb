#!/usr/bin/env ruby
# frozen_string_literal: true

# Posts new event announcement to Twitter/X using API v2.
#
# Required environment variables:
#   TWITTER_API_KEY
#   TWITTER_API_SECRET
#   TWITTER_ACCESS_TOKEN
#   TWITTER_ACCESS_TOKEN_SECRET
#
# Usage:
#   ruby scripts/post_twitter.rb

require "yaml"
require "x"

DATA_FILE = File.expand_path("../_data/eventos.yml", __dir__)

def load_latest_event
  events = YAML.safe_load_file(DATA_FILE)
  return nil if events.nil? || events.empty?

  events.first
end

def build_message(event)
  lines = []
  lines << "#{event['title']}"
  lines << ""
  lines << "#{event['date_display']}"
  lines << "#{event['time_display']}" if event["time_display"]
  lines << "#{event['venue']}" if event["venue"]
  lines << ""
  lines << "Registro: #{event['eventbrite_url']}" if event["eventbrite_url"]
  lines << ""
  lines << "#Oaxacoders #Oaxaca #Tech #Programacion"

  lines.join("\n")
end

# Main
event = load_latest_event
if event.nil?
  puts "No events found in datos file."
  exit 0
end

credentials = {
  api_key: ENV.fetch("TWITTER_API_KEY"),
  api_key_secret: ENV.fetch("TWITTER_API_SECRET"),
  access_token: ENV.fetch("TWITTER_ACCESS_TOKEN"),
  access_token_secret: ENV.fetch("TWITTER_ACCESS_TOKEN_SECRET")
}

client = X::Client.new(**credentials)
message = build_message(event)

puts "Posting to Twitter:"
puts message
puts "---"

response = client.post("tweets", "{\"text\":#{message.to_json}}")
tweet_id = response.is_a?(Hash) ? response.dig("data", "id") : nil
puts "Tweet posted#{tweet_id ? ": #{tweet_id}" : "."}"
