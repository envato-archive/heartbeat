Rails.application.routes.draw do

  mount Heartbeat::Engine => "/"
end
