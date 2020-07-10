threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart

bind "unix://#{Rails.root}/tmp/sockets/puma.sock"

stdout_redirect "#{Rails.root}/log/puma.stdout.log", "#{Rails.root}/log/puma.stderr.log", true
