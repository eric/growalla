#!/usr/bin/env ruby

require 'feedzirra'
require 'lib/growalla_avatar_cache'
require 'lib/gowalla_feedzirra_parsers'

# Seconds
INTERVAL = 60

unless username = ARGV[0]
  puts "Usage: #{File.basename($0)} <username>"
  exit 1
end

avatar_cache = GrowallaAvatarCache.new('gowalla-avatar-cache')
feed         = Feedzirra::Feed.fetch_and_parse("http://gowalla.com/users/#{username}/friends_visits.atom")

loop do
  feed.new_entries.last(2).each do |entry|
    command = %W(/usr/local/bin/growlnotify #{entry.location.title} -m #{entry.summary})

    if image = avatar_cache.image_badge(entry.actor.image_url, entry.location.image_url)
      command += %W(--image #{image})
    end

    system *command
  end

  # Clear out the new_entries
  feed.new_entries = []

  sleep INTERVAL

  if (updated_feed = Feedzirra::Feed.update(feed)).is_a?(Numeric)
    puts "Got HTTP error #{updated_feed}"
  else
    feed = updated_feed
  end
end
