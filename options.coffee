# load data into form

load_data = () ->
  chrome.storage.local.get ["fixed_servers"], (data) ->
    unless data.fixed_servers
      data.fixed_servers = {}
    fixed_servers = data.fixed_servers
    unless fixed_servers.host
      fixed_servers.host = "127.0.0.1"
    unless fixed_servers.port
      fixed_servers.port = "7070"
    for k,v of fixed_servers
      document.querySelector("#"+k).setAttribute("value",v)


save_data = () ->
  fixed_servers = {host:"",port:""}
  for k of fixed_servers
    fixed_servers[k] = document.querySelector('#'+k).value
  chrome.storage.local.set {fixed_servers},->


document.addEventListener('DOMContentLoaded', load_data)
document.querySelector('#save').addEventListener 'click', save_data