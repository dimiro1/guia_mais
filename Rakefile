# -*- coding: utf-8 -*-
require "rubygems"
require "rake"
require "echoe"

Echoe.new("guia_mais", "0.1") do |p|
  p.description = "Busca dados no site Guia Mais através do telefone"
  p.author = "Claudemiro Alves Feitosa Neto"
  p.email = "dimiro1@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = ["hpricot", "httparty"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
