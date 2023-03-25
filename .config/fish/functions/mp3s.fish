function mp3s --wraps='yt-dlp --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"' --description 'mp3s <search-youtube>'
  yt-dlp --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" "ytsearch:$argv";
end
