((text) @injection.content
    (#not-has-ancestor? @injection.content "envoy")
    (#set! injection.combined)
    (#set! injection.language php))
((text) @injection.content
    (#set! injection.language "html")
    (#set! injection.combined))
((text) @injection.content
    (#set! injection.language "php")
    (#set! injection.combined))
((parameter) @injection.content
    (#set! injection.language php))
