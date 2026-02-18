#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches ended events from Eventbrite API v3 and generates
# Jekyll blog posts with placeholder sections for slides, photos,
# and resources.
#
# Local-only script — not intended for CI.
#
# Required environment variables (via .env or shell):
#   EVENTBRITE_TOKEN  - Eventbrite API private token
#   EVENTBRITE_ORG_ID - Eventbrite organization ID
#
# Usage:
#   ruby scripts/generate_past_event_posts.rb

require "net/http"
require "json"
require "yaml"
require "fileutils"
require "uri"
require "time"

# Load .env file if present
env_file = File.expand_path("../.env", __dir__)
if File.exist?(env_file)
  File.readlines(env_file).each do |line|
    line = line.strip
    next if line.empty? || line.start_with?("#")

    key, value = line.split("=", 2)
    next unless key && value

    value = value.strip
    # Strip surrounding quotes
    value = value[1..-2] if (value.start_with?('"') && value.end_with?('"')) ||
                            (value.start_with?("'") && value.end_with?("'"))
    ENV[key.strip] = value
  end
end

EVENTBRITE_API = "https://www.eventbriteapi.com/v3"
TOKEN = ENV.fetch("EVENTBRITE_TOKEN")
ORG_ID = ENV.fetch("EVENTBRITE_ORG_ID")

POSTS_DIR = File.expand_path("../_posts", __dir__)

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

def fetch_ended_events
  events = []
  continuation = nil

  loop do
    path = "/organizations/#{ORG_ID}/events/" \
           "?status=ended&order_by=start_desc&expand=venue"
    path += "&continuation=#{continuation}" if continuation

    data = api_get(path)
    break unless data

    events.concat(data.fetch("events", []))

    continuation = data.dig("pagination", "continuation")
    has_more = data.dig("pagination", "has_more_items")
    break unless has_more && continuation
  end

  events
end

def process_event(event)
  name = sanitize_text(event["name"]["text"] || "Sin titulo")[0, MAX_TITLE_LENGTH]
  description = sanitize_text(event.dig("description", "text") || "")[0, MAX_DESCRIPTION_LENGTH]
  eventbrite_url = event["url"]

  start_utc = Time.parse(event.dig("start", "utc"))
  end_utc = Time.parse(event.dig("end", "utc"))
  start_local = event.dig("start", "local")
  end_local = event.dig("end", "local")

  start_time = Time.parse(start_local || start_utc.to_s)
  end_time = Time.parse(end_local || end_utc.to_s)

  venue = event.dig("venue", "name")
  venue_address = event.dig("venue", "address", "localized_address_display")

  date_str = start_time.strftime("%Y-%m-%d")
  slug = slugify(name)
  filename = "#{date_str}-#{slug}.md"

  {
    "title" => name,
    "slug" => slug,
    "date" => date_str,
    "date_display" => format_spanish_date(start_time),
    "time_display" => format_time_range(start_time, end_time),
    "venue" => venue,
    "venue_address" => venue_address,
    "eventbrite_url" => eventbrite_url,
    "description" => description,
    "filename" => filename
  }
end

def write_post_file(event_data)
  filepath = File.join(POSTS_DIR, event_data["filename"])

  if File.exist?(filepath)
    puts "  Skipping existing: #{event_data['filename']}"
    return false
  end

  front_matter = {
    "layout" => "evento-pasado",
    "title" => event_data["title"],
    "date" => event_data["date"],
    "date_display" => event_data["date_display"],
    "time_display" => event_data["time_display"],
    "venue" => event_data["venue"],
    "venue_address" => event_data["venue_address"],
    "eventbrite_url" => event_data["eventbrite_url"],
    "category" => "eventos-pasados",
    "slides_url" => "",
    "slides_type" => "",
    "fotos" => [],
    "recursos" => []
  }

  body = <<~MARKDOWN

    ## Resumen

    #{event_data['description']}

    ## Presentación

    <!-- Para agregar slides, edita el front matter de este archivo:
         slides_url: "https://docs.google.com/presentation/d/.../embed"
         slides_type: "google-slides"
         O para PDF:
         slides_url: "/assets/slides/mi-presentacion.pdf"
         slides_type: "pdf" -->

    ## Fotos

    <!-- Para agregar fotos, edita el front matter de este archivo:
         fotos:
           - url: "/assets/fotos/evento/foto1.jpg"
             caption: "Descripción de la foto"
           - url: "/assets/fotos/evento/foto2.jpg"
             caption: "Otra descripción" -->

    ## Recursos

    <!-- Para agregar recursos, edita el front matter de este archivo:
         recursos:
           - titulo: "Repositorio del proyecto"
             url: "https://github.com/..."
           - titulo: "Documentación"
             url: "https://..." -->
  MARKDOWN

  content = "#{front_matter.to_yaml}---\n#{body}"
  File.write(filepath, content)
  puts "  Created: #{event_data['filename']}"
  true
end

# Main
puts "Fetching ended events from Eventbrite..."
raw_events = fetch_ended_events

if raw_events.empty?
  puts "No ended events found."
  exit 0
end

puts "Found #{raw_events.size} ended event(s)."

FileUtils.mkdir_p(POSTS_DIR)
events_data = raw_events.map { |e| process_event(e) }

created = 0
skipped = 0
events_data.each do |event_data|
  if write_post_file(event_data)
    created += 1
  else
    skipped += 1
  end
end

puts ""
puts "Done: #{created} post(s) created, #{skipped} skipped."
