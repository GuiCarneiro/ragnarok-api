require 'rubygems'
require 'bundler'

# Irá requerer todos as nossas dependencias
# por meio do bundler
Bundler.require(:default)

# Irá inicializar qualquer arquivo .rb
# que encontrar dentro das pastas
Dir["./*/*.rb"].each {|file| require file }
