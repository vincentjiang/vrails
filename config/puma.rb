#!/usr/bin/env puma

#rails的运行环境
environment 'production'
threads 4, 32
workers 2

#项目名
app_name = "vrails"
#项目路径
application_path = "/home/deployer/#{app_name}"
#这里一定要配置为项目路径下的current
directory "#{application_path}/current"

#下面都是 puma的配置项
pidfile "#{application_path}/shared/tmp/pids/puma.pid"
stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log"
bind "unix://#{application_path}/shared/tmp/sockets/puma.sock"

preload_app!
activate_control_app

on_worker_boot do
  puts 'On worker boot...'
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

#后台运行
daemonize true
on_restart do
  puts 'On restart...'
end