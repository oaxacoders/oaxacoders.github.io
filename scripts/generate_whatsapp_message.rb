#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates a pre-formatted WhatsApp message for manual sharing.
# Outputs the message text and a wa.me share link.
#
# Usage:
#   ruby scripts/generate_whatsapp_message.rb

require "yaml"
require "uri"
require "tmpdir"

DATA_FILE = File.expand_path("../_data/eventos.yml", __dir__)

def load_latest_event
  events = YAML.safe_load_file(DATA_FILE)
  return nil if events.nil? || events.empty?

  events.first
end

def build_message(event)
  lines = []
  lines << "*#{event['title']}*"
  lines << ""
  lines << "#{event['date_display']}"
  lines << "#{event['time_display']}" if event["time_display"]
  lines << "#{event['venue']}" if event["venue"]
  lines << ""
  lines << "Registrate aqui: #{event['eventbrite_url']}" if event["eventbrite_url"]
  lines << ""
  lines << "#Oaxacoders"

  lines.join("\n")
end

# Main
event = load_latest_event
if event.nil?
  puts "No events found."
  exit 0
end

message = build_message(event)
encoded = URI.encode_www_form_component(message)
share_link = "https://wa.me/?text=#{encoded}"

puts "WhatsApp message:"
puts "---"
puts message
puts "---"
puts ""
puts "Share link:"
puts share_link

# Write to file for artifact upload
output_dir = ENV["RUNNER_TEMP"] || Dir.tmpdir
output_path = File.join(output_dir, "whatsapp_message.txt")
File.write(output_path, "#{message}\n\nShare link: #{share_link}\n")
puts "\nSaved to #{output_path}"

# Export path for workflow artifact upload
if ENV["GITHUB_OUTPUT"]
  File.open(ENV["GITHUB_OUTPUT"], "a") { |f| f.puts "whatsapp_message_path=#{output_path}" }
end
