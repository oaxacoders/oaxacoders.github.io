#!/usr/bin/env ruby
# frozen_string_literal: true

# Sends event announcement to Telegram channel/group.
#
# Required environment variables:
#   TELEGRAM_BOT_TOKEN - Bot token from @BotFather
#   TELEGRAM_CHAT_ID   - Channel or group chat ID
#
# Usage:
#   ruby scripts/notify_telegram.rb

require "net/http"
require "json"
require "yaml"
require "uri"

BOT_TOKEN = ENV.fetch("TELEGRAM_BOT_TOKEN")
CHAT_ID = ENV.fetch("TELEGRAM_CHAT_ID")

DATA_FILE = File.expand_path("../_data/eventos.yml", __dir__)

def escape_markdown(text)
  return "" if text.nil?

  text.gsub(/([_*\[\]()~`>#+\-=|{}.!])/, '\\\\\1')
end

def send_message(text)
  uri = URI("https://api.telegram.org/bot#{BOT_TOKEN}/sendMessage")
  req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
  req.body = {
    chat_id: CHAT_ID,
    text: text,
    parse_mode: "MarkdownV2",
    disable_web_page_preview: false
  }.to_json

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 10) do |http|
    http.request(req)
  end

  unless response.is_a?(Net::HTTPSuccess)
    warn "Telegram API error (HTTP #{response.code})"
    return nil
  end

  JSON.parse(response.body)
end

def load_latest_event
  events = YAML.safe_load_file(DATA_FILE)
  return nil if events.nil? || events.empty?

  events.first
end

def build_message(event)
  title = escape_markdown(event["title"])
  date = escape_markdown(event["date_display"])
  time = escape_markdown(event["time_display"])
  venue = escape_markdown(event["venue"])
  url = event["eventbrite_url"]

  lines = []
  lines << "*#{title}*"
  lines << ""
  lines << "#{date}"
  lines << "#{time}" if time && !time.empty?
  lines << "#{venue}" if venue && !venue.empty?
  lines << ""
  lines << "[Registrarse](#{url})" if url
  lines << ""
  lines << "\\#Oaxacoders"

  lines.join("\n")
end

# Main
event = load_latest_event
if event.nil?
  puts "No events found."
  exit 0
end

message = build_message(event)
puts "Sending to Telegram:"
puts message
puts "---"

result = send_message(message)
if result && result["ok"]
  puts "Message sent to chat #{CHAT_ID}."
else
  warn "Failed to send Telegram message."
  exit 1
end
