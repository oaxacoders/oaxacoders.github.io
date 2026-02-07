#!/usr/bin/env ruby
# frozen_string_literal: true

# Posts new event announcement to BlueSky via AT Protocol.
#
# Required environment variables:
#   BLUESKY_HANDLE   - e.g. "oaxacoders.bsky.social"
#   BLUESKY_PASSWORD - App password from Settings > App Passwords
#
# Usage:
#   ruby scripts/post_bluesky.rb

require "net/http"
require "json"
require "yaml"
require "uri"
require "time"

BLUESKY_API = "https://bsky.social/xrpc"
HANDLE = ENV.fetch("BLUESKY_HANDLE")
PASSWORD = ENV.fetch("BLUESKY_PASSWORD")

DATA_FILE = File.expand_path("../_data/eventos.yml", __dir__)

def api_post(endpoint, body, access_jwt: nil)
  uri = URI("#{BLUESKY_API}/#{endpoint}")
  req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
  req["Authorization"] = "Bearer #{access_jwt}" if access_jwt
  req.body = body.to_json

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 10) do |http|
    http.request(req)
  end

  unless response.is_a?(Net::HTTPSuccess)
    warn "BlueSky API error (HTTP #{response.code})"
    return nil
  end

  JSON.parse(response.body)
end

def authenticate
  result = api_post("com.atproto.server.createSession", {
    identifier: HANDLE,
    password: PASSWORD
  })

  return nil unless result

  { did: result["did"], access_jwt: result["accessJwt"] }
end

def load_latest_event
  events = YAML.safe_load_file(DATA_FILE)
  return nil if events.nil? || events.empty?

  events.first
end

def build_message(event)
  lines = []
  lines << event["title"]
  lines << ""
  lines << event["date_display"]
  lines << event["time_display"] if event["time_display"]
  lines << event["venue"] if event["venue"]
  lines << ""
  lines << "Registro: #{event['eventbrite_url']}" if event["eventbrite_url"]
  lines << ""
  lines << "#Oaxacoders #Oaxaca #Tech"

  lines.join("\n")
end

def create_post(session, text)
  record = {
    "$type" => "app.bsky.feed.post",
    "text" => text,
    "createdAt" => Time.now.utc.iso8601,
    "langs" => ["es"]
  }

  api_post("com.atproto.repo.createRecord", {
    repo: session[:did],
    collection: "app.bsky.feed.post",
    record: record
  }, access_jwt: session[:access_jwt])
end

# Main
event = load_latest_event
if event.nil?
  puts "No events found."
  exit 0
end

puts "Authenticating with BlueSky..."
session = authenticate
if session.nil?
  warn "Failed to authenticate with BlueSky."
  exit 1
end

message = build_message(event)
puts "Posting to BlueSky:"
puts message
puts "---"

result = create_post(session, message)
if result
  puts "Post created: #{result['uri']}"
else
  warn "Failed to create post."
  exit 1
end
