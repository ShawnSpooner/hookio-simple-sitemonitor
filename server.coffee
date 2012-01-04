SiteMon = require('hook.io-sitemonitor').SiteMonitorHook
Hook = require('hook.io').Hook

receiver = new Hook
  name: 'server-hook'
  hooks: ['mailer']
  
siteMonitor = new SiteMon
  name:'site-monitor'

receiver.on 'hook::ready', () ->
  console.log 'hook reporting for duty'
  siteMonitor.start()
  
  receiver.on '*::site::down', (data)->
    subject = "#{data.name} is down at #{data.url}"
    console.log subject
    sendEmail buildMessage subject
    
  receiver.on '*::site::backOnline', (data)->
    subject = "#{data.name} is back up  at #{data.url}"
    console.log subject
    sendEmail buildMessage subject

   
receiver.start()

sendEmail = (message) ->
  receiver.emit 'sendEmail', message
  
buildMessage = (subject, body="") ->
  to      : 'youremail@here.com'
  from    : 'mailer@hook.io'
  subject : subject
  body    : body
