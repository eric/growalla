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
    command = %W(/usr/local/bin/growlnotify #{location.title} -m #{entry.summary})

    if image = avatar_cache.image_badge(entry.actor.image_url, entry.location.image_url)
      command += %W(--image #{image})
    end

    system *command
  end

  sleep INTERVAL
  feed = Feedzirra::Feed.update(feed)
end
