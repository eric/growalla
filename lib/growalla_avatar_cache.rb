class GrowallaAvatarCache
  attr_accessor :cache_dir

  def initialize(cache_dir)
    @cache_dir = File.expand_path(cache_dir)

    unless File.directory?(@cache_dir)
      Dir.mkdir(@cache_dir)
    end
  end

  def image_badge(big_url, small_url)
    big_token   = File.basename(big_url)[/([^\.]+)/, 1]
    small_token = File.basename(small_url)[/([^\.]+)/, 1]

    output_file = File.join(cache_dir, "#{big_token}-#{small_token}.png")

    command = %(convert -geometry 40x40 '#{small_url}' png:- | composite -gravity southeast png:- "#{big_url}" "#{output_file}")

    if system '/bin/bash', '-c', command
      File.expand_path(output_file)
    end
  end
end
