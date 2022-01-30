function mp3 --wraps='youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"' --description 'alias mp3=youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s"'
  youtube-dl --extract-audio --audio-format mp3 -o "%(title)s.%(ext)s" $argv; 
end
