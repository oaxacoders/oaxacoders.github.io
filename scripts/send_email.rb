#!/usr/bin/env ruby
# frozen_string_literal: true

# Sends event announcement email via Buttondown API.
#
# Required environment variables:
#   BUTTONDOWN_API_KEY - API key from Buttondown Settings > Programming
#
# Usage:
#   ruby scripts/send_email.rb

require "net/http"
require "json"
require "yaml"
require "uri"

API_KEY = ENV.fetch("BUTTONDOWN_API_KEY")
BUTTONDOWN_API = "https://api.buttondown.com"

DATA_FILE = File.expand_path("../_data/eventos.yml", __dir__)

def load_latest_event
  events = YAML.safe_load_file(DATA_FILE)
  return nil if events.nil? || events.empty?

  events.first
end

def build_email_body(event)
  lines = []
  lines << "# #{event['title']}"
  lines << ""
  lines << "**#{event['date_display']}**"
  lines << "#{event['time_display']}" if event["time_display"]
  lines << "#{event['venue']}" if event["venue"]
  lines << ""
  lines << event["description"] if event["description"] && !event["description"].empty?
  lines << ""
  lines << "[Registrarse en Eventbrite](#{event['eventbrite_url']})" if event["eventbrite_url"]
  lines << ""
  lines << "---"
  lines << "*Oaxacoders — Comunidad de programadores en Oaxaca*"

  lines.join("\n")
end

def send_email(subject, body)
  uri = URI("#{BUTTONDOWN_API}/v1/emails")
  req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
  req["Authorization"] = "Token #{API_KEY}"
  req.body = {
    subject: subject,
    body: body,
    status: "draft"
  }.to_json

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 10) do |http|
    http.request(req)
  end

  unless response.is_a?(Net::HTTPSuccess)
    warn "Buttondown API error (HTTP #{response.code})"
    return nil
  end

  JSON.parse(response.body)
end

# Main
event = load_latest_event
if event.nil?
  puts "No events found."
  exit 0
end

subject = "Nuevo evento: #{event['title']}"
body = build_email_body(event)

puts "Creating email draft:"
puts "Subject: #{subject}"
puts "---"
puts body
puts "---"

result = send_email(subject, body)
if result
  puts "Email draft created: #{result['id']}"
else
  warn "Failed to create email draft."
  exit 1
end
