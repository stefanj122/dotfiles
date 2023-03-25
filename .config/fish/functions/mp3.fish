function mp3 --wraps='yt-dlp --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"' --description 'mp3 <youtube-music-url>'
  yt-dlp --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" $argv;
end
