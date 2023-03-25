function mp3 --wraps='yt-dlp --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"' --description 'alias mp3=yt-dlp --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"'
  yt-dlp --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" $argv;
end
