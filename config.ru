require 'sinatra'
require './app'

# Setando o nosso json encoder
configure do
  set :json_encoder, :to_json
end

# Configurando os headers das nossas requests
before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

#Iniciando nosso App
run Sinatra::Application
