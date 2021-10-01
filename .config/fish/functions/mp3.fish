function mp3 --description 'alias mp3=youtube-dl -x --audio-format mp3'
  youtube-dl -x --audio-format mp3 $argv; 
end
