#!/usr/bin/env ruby
# frozen_string_literal: true

# Verifies connectivity to all external APIs used by the ecosystem.
#
# Environment variables (all optional — skips check if not set):
#   EVENTBRITE_TOKEN, EVENTBRITE_ORG_ID
#   TWITTER_API_KEY, TWITTER_API_SECRET, TWITTER_ACCESS_TOKEN, TWITTER_ACCESS_TOKEN_SECRET
#   BLUESKY_HANDLE, BLUESKY_PASSWORD
#   TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID
#   BUTTONDOWN_API_KEY
#
# Usage:
#   ruby scripts/health_check.rb

require "net/http"
require "json"
require "uri"

CHECKS = []
PASS = "PASS"
FAIL = "FAIL"
SKIP = "SKIP"

def check(name)
  CHECKS << { name: name, status: SKIP, detail: "Not configured" }
  yield CHECKS.last
rescue StandardError => e
  CHECKS.last[:status] = FAIL
  CHECKS.last[:detail] = e.message
end

def http_get(url, headers = {})
  uri = URI(url)
  req = Net::HTTP::Get.new(uri)
  headers.each { |k, v| req[k] = v }
  Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 10) { |http| http.request(req) }
end

def http_post(url, body, headers = {})
  uri = URI(url)
  req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
  headers.each { |k, v| req[k] = v }
  req.body = body.to_json
  Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 10, read_timeout: 10) { |http| http.request(req) }
end

# Eventbrite
check("Eventbrite") do |c|
  token = ENV["EVENTBRITE_TOKEN"]
  org_id = ENV["EVENTBRITE_ORG_ID"]
  next unless token && org_id

  resp = http_get(
    "https://www.eventbriteapi.com/v3/users/me/",
    "Authorization" => "Bearer #{token}"
  )
  if resp.is_a?(Net::HTTPSuccess)
    data = JSON.parse(resp.body)
    c[:status] = PASS
    c[:detail] = "User: #{data['name']}"
  else
    c[:status] = FAIL
    c[:detail] = "HTTP #{resp.code}"
  end
end

# Twitter/X
check("Twitter/X") do |c|
  key = ENV["TWITTER_API_KEY"]
  secret = ENV["TWITTER_API_SECRET"]
  next unless key && secret

  # Verify credentials by requesting a bearer token
  uri = URI("https://api.x.com/oauth2/token")
  req = Net::HTTP::Post.new(uri)
  req.basic_auth(key, secret)
  req.set_form_data("grant_type" => "client_credentials")
  resp = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }

  if resp.is_a?(Net::HTTPSuccess)
    c[:status] = PASS
    c[:detail] = "Bearer token obtained"
  else
    c[:status] = FAIL
    c[:detail] = "HTTP #{resp.code}"
  end
end

# BlueSky
check("BlueSky") do |c|
  handle = ENV["BLUESKY_HANDLE"]
  password = ENV["BLUESKY_PASSWORD"]
  next unless handle && password

  resp = http_post("https://bsky.social/xrpc/com.atproto.server.createSession", {
    identifier: handle,
    password: password
  })

  if resp.is_a?(Net::HTTPSuccess)
    c[:status] = PASS
    c[:detail] = "Authenticated as #{handle}"
  else
    c[:status] = FAIL
    c[:detail] = "HTTP #{resp.code}"
  end
end

# Telegram
check("Telegram") do |c|
  token = ENV["TELEGRAM_BOT_TOKEN"]
  next unless token

  resp = http_get("https://api.telegram.org/bot#{token}/getMe")
  if resp.is_a?(Net::HTTPSuccess)
    data = JSON.parse(resp.body)
    c[:status] = PASS
    c[:detail] = "Bot: @#{data.dig('result', 'username')}"
  else
    c[:status] = FAIL
    c[:detail] = "HTTP #{resp.code}"
  end
end

# Buttondown
check("Buttondown") do |c|
  key = ENV["BUTTONDOWN_API_KEY"]
  next unless key

  resp = http_get(
    "https://api.buttondown.com/v1/newsletters",
    "Authorization" => "Token #{key}"
  )
  if resp.is_a?(Net::HTTPSuccess)
    c[:status] = PASS
    c[:detail] = "API key valid"
  else
    c[:status] = FAIL
    c[:detail] = "HTTP #{resp.code}"
  end
end

# Report
puts ""
puts "Oaxacoders Health Check"
puts "=" * 40
CHECKS.each do |c|
  icon = case c[:status]
         when PASS then "+"
         when FAIL then "x"
         else "-"
         end
  puts "[#{icon}] #{c[:name]}: #{c[:status]} — #{c[:detail]}"
end
puts "=" * 40

failures = CHECKS.count { |c| c[:status] == FAIL }
if failures > 0
  puts "#{failures} check(s) failed."
  exit 1
else
  puts "All configured checks passed."
end
