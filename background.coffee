
test_proxy = (cb) ->
  cb true

is_config_valid = (conf) ->
  typeof conf == "object" and conf.host.trim() and /\d+/.exec conf.port.trim()
  
proxy = (enable, conf, cb) ->
  if enable and is_config_valid conf
    config =
      mode: "fixed_servers"
      rules:
        singleProxy:
          scheme: "socks5"
          host: conf.host
          port: Number(conf.port)
        bypassList: conf.bypassList
    chrome.proxy.settings.set {value:config,scope:'regular'}, test_proxy cb
  else
    unless is_config_valid conf
      chrome.tabs.create({url: "options.html"})
      alert "[WARN]: SOCKS5 proxy is not configured yet. \n\nPlease configure and save it."
    config = {mode: "direct"}
    chrome.proxy.settings.set {value:config, scope:'regular'}, -> cb null
  
switch_proxy = () ->
  
  chrome.storage.local.get ["enabled","fixed_servers"], (data)->
  
    data.enabled = not data.enabled

    proxy data.enabled, data.fixed_servers, (enabled) ->
      data.enabled = enabled
      chrome.storage.local.set data, () ->
        if chrome.runtime.lastError
          console.error chrome.runtime.lastError
        display_status()      

display_status = ()->
  chrome.storage.local.get "enabled", (data) ->
    chrome.browserAction.setBadgeText {text: if data.enabled then "on" else "off"}
  
chrome.runtime.onStartup.addListener(display_status)
chrome.runtime.onInstalled.addListener(display_status)
chrome.browserAction.onClicked.addListener(switch_proxy)
  
      
  
      
      
        
        
        
        
  