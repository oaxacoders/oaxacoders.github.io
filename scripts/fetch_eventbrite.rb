#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches live events from Eventbrite API v3 and generates
# Jekyll-compatible event files and data.
#
# Required environment variables:
#   EVENTBRITE_TOKEN  - Eventbrite API private token
#   EVENTBRITE_ORG_ID - Eventbrite organization ID
#
# Usage:
#   ruby scripts/fetch_eventbrite.rb

require "net/http"
require "json"
require "yaml"
require "fileutils"
require "uri"
require "time"

EVENTBRITE_API = "https://www.eventbriteapi.com/v3"
TOKEN = ENV.fetch("EVENTBRITE_TOKEN")
ORG_ID = ENV.fetch("EVENTBRITE_ORG_ID")

EVENTS_DIR = File.expand_path("../_events", __dir__)
DATA_FILE = File.expand_path("../_data/eventos.yml", __dir__)

SPANISH_MONTHS = {
  1 => "enero", 2 => "febrero", 3 => "marzo", 4 => "abril",
  5 => "mayo", 6 => "junio", 7 => "julio", 8 => "agosto",
  9 => "septiembre", 10 => "octubre", 11 => "noviembre", 12 => "diciembre"
}.freeze

MAX_TITLE_LENGTH = 200
MAX_DESCRIPTION_LENGTH = 10_000

def sanitize_text(text)
  return "" if text.nil?

  text.gsub(/<script[\s>].*?<\/script>/mi, "")
      .gsub(/<[^>]+>/, "")
      .gsub(/^---\s*$/, "")
      .strip
end

def sanitize_html(html)
  return "" if html.nil?

  html.gsub(/<script[\s>].*?<\/script>/mi, "")
      .gsub(/on\w+\s*=\s*"[^"]*"/i, "")
      .gsub(/on\w+\s*=\s*'[^']*'/i, "")
      .strip
end

def api_get(path)
  uri = URI("#{EVENTBRITE_API}#{path}")
  req = Net::HTTP::Get.new(uri)
  req["Authorization"] = "Bearer #{TOKEN}"

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 10) do |http|
    http.request(req)
  end

  unless response.is_a?(Net::HTTPSuccess)
    warn "Eventbrite API error (HTTP #{response.code})"
    return nil
  end

  JSON.parse(response.body)
end

def format_spanish_date(time)
  day = time.day
  month = SPANISH_MONTHS[time.month]
  year = time.year
  "#{day} de #{month}, #{year}"
end

def format_time_range(start_time, end_time)
  start_str = start_time.strftime("%H:%M")
  end_str = end_time.strftime("%H:%M")
  "#{start_str} - #{end_str}"
end

def slugify(text)
  text.downcase
      .gsub(/[^a-z0-9\s-]/, "")
      .gsub(/[\s]+/, "-")
      .gsub(/-+/, "-")
      .gsub(/^-|-$/, "")
end

def fetch_events
  path = "/organizations/#{ORG_ID}/events/" \
         "?status=live&order_by=start_asc&expand=venue,ticket_availability"
  data = api_get(path)
  return [] unless data

  data.fetch("events", [])
end

def process_event(event)
  name = sanitize_text(event["name"]["text"] || "Sin titulo")[0, MAX_TITLE_LENGTH]
  description = sanitize_text(event.dig("description", "text") || "")[0, MAX_DESCRIPTION_LENGTH]
  html_description = sanitize_html(event.dig("description", "html") || "")[0, MAX_DESCRIPTION_LENGTH]
  eventbrite_url = event["url"]
  eventbrite_id = event["id"]

  start_utc = Time.parse(event.dig("start", "utc"))
  end_utc = Time.parse(event.dig("end", "utc"))
  start_local = event.dig("start", "local")
  end_local = event.dig("end", "local")

  start_time = Time.parse(start_local || start_utc.to_s)
  end_time = Time.parse(end_local || end_utc.to_s)

  venue = event.dig("venue", "name")
  venue_address = event.dig("venue", "address", "localized_address_display")

  is_free = event.dig("ticket_availability", "is_free") || false
  status = event.dig("ticket_availability", "has_available_tickets") ? "disponible" : "agotado"

  date_str = start_time.strftime("%Y-%m-%d")
  slug = slugify(name)
  filename = "#{date_str}-#{slug}.md"

  {
    "title" => name,
    "slug" => slug,
    "date" => date_str,
    "date_display" => format_spanish_date(start_time),
    "time_display" => format_time_range(start_time, end_time),
    "start_time" => start_local,
    "end_time" => end_local,
    "venue" => venue,
    "venue_address" => venue_address,
    "eventbrite_url" => eventbrite_url,
    "eventbrite_id" => eventbrite_id,
    "is_free" => is_free,
    "status" => status,
    "description" => description,
    "html_description" => html_description,
    "filename" => filename
  }
end

def write_event_file(event_data)
  filepath = File.join(EVENTS_DIR, event_data["filename"])

  if File.exist?(filepath)
    puts "  Skipping existing: #{event_data['filename']}"
    return false
  end

  front_matter = {
    "layout" => "event",
    "title" => event_data["title"],
    "date" => event_data["date"],
    "date_display" => event_data["date_display"],
    "time_display" => event_data["time_display"],
    "venue" => event_data["venue"],
    "venue_address" => event_data["venue_address"],
    "eventbrite_url" => event_data["eventbrite_url"],
    "eventbrite_id" => event_data["eventbrite_id"],
    "is_free" => event_data["is_free"],
    "status" => event_data["status"]
  }

  content = "#{front_matter.to_yaml}---\n\n#{event_data['description']}\n"
  File.write(filepath, content)
  puts "  Created: #{event_data['filename']}"
  true
end

def write_data_file(events_data)
  clean_data = events_data.map do |e|
    e.reject { |k, _| k == "filename" || k == "html_description" }
  end

  File.write(DATA_FILE, clean_data.to_yaml)
  puts "  Updated: _data/eventos.yml (#{events_data.size} events)"
end

# Main
puts "Fetching events from Eventbrite..."
raw_events = fetch_events

if raw_events.empty?
  puts "No live events found."
  exit 0
end

puts "Found #{raw_events.size} live event(s)."

FileUtils.mkdir_p(EVENTS_DIR)
events_data = raw_events.map { |e| process_event(e) }

new_events = false
events_data.each do |event_data|
  new_events = true if write_event_file(event_data)
end

write_data_file(events_data)

if new_events
  puts "New events were added."
else
  puts "No new events to add."
end
