# -*- coding: utf-8 -*-

# -*- coding: utf-8 -*-
# TODO: correção de erros
require "rubygems"
require "hpricot"
require 'open-uri'
require 'net/http'
require 'timeout'

class String
  def to_utf8
    unpack("C*").pack("U*")
  end

  def to_iso88591
    array_utf8 = self.unpack('U*')
    array_enc = []
    array_utf8.each do |num|
      if num <= 0xFF
        array_enc << num
      else
        array_enc.concat "&\#\#{num};".unpack('C*')
      end
    end
    array_enc.pack('C*')
  end
end

module GuiaMais
  class GuiaMaisException < Exception
  end

  class Cliente
    attr_reader :nome, :endereco, :bairro, :cep, :categoria
    def initialize(nome, endereco, bairro, cep, categoria)
      @nome = nome
      @endereco = endereco
      @bairro = bairro
      @cep = cep
      @categoria = categoria
    end
  end

  ESTADOS = {
    :acre                => {:guia => 579, :sigla => 'AC'},
    :alagoas             => {:guia => 580, :sigla => 'AL'},
    :amazonas            => {:guia => 325, :sigla => 'AM'},
    :amapa               => {:guia => 581, :sigla => 'AP'},
    :bahia               => {:guia => 326, :sigla => 'BA'},
    :ceara               => {:guia => 582, :sigla => 'CE'},
    :distrito_federal    => {:guia => 327, :sigla => 'DF'},
    :espirito_santo      => {:guia => 328, :sigla => 'ES'},
    :goias               => {:guia => 329, :sigla => 'GO'},
    :maranhao            => {:guia => 584, :sigla => 'MA'},
    :minas_gerais        => {:guia => 585, :sigla => 'MG'},
    :mato_grosso_do_sul  => {:guia => 586, :sigla => 'MS'},
    :mato_grosso         => {:guia => 587, :sigla => 'MT'},
    :para                => {:guia => 330, :sigla => 'PA'},
    :paraiba             => {:guia => 588, :sigla => 'PB'},
    :pernambuco          => {:guia => 589, :sigla => 'PE'},
    :piaui               => {:guia => 590, :sigla => 'PI'},
    :parana              => {:guia => 331, :sigla => 'PR'},
    :rio_de_janeiro      => {:guia => 333, :sigla => 'RJ'},
    :rio_grande_do_norte => {:guia => 591, :sigla => 'RN'},
    :rondonia            => {:guia => 592, :sigla => 'RO'},
    :roraima             => {:guia => 593, :sigla => 'RR'},
    :rio_grande_do_sul   => {:guia => 334, :sigla => 'RS'},
    :santa_catarina      => {:guia => 335, :sigla => 'SC'},
    :sergipe             => {:guia => 594, :sigla => 'SE'},
    :sao_paulo           => {:guia => 336, :sigla => 'SP'},
    :tocantins           => {:guia => 595, :sigla => 'TO'}
  }
  
  class Selector
    attr_reader :source
    def initialize(source)
      @source = Hpricot(source.to_utf8)
    end

    def fetch(selector)
      result = @source.search(selector).first
      result ? result.inner_html : nil
    end
  end

  class Minerador
    @@url = "http://www.guiamais.com.br/Results.aspx"
    @@source = String.new

    def self.iniciar(telefone, options = {})
      options[:txb] = telefone
      options[:nes] ||= ESTADOS[options[:estado]][:sigla] if options[:estado]
      options[:ies] ||= ESTADOS[options[:estado]][:guia] if options[:estado]
      options.delete(:estado)
      query = "?"
      options.each {|param| query += "#{param[0]}=#{param[1]}&"}
      query = query.slice(0...query.length - 1)
      response = Net::HTTP.get_response(URI.parse(@@url + query))
      minerar_dados(response.body)
    end

    private

    def self.minerar_dados(source)
      selector = Selector.new(source)
      nome, endereco, bairro, cep, categoria = nil
      begin
        timeout(10) do
          nome = selector.fetch("div#ctl00_C1_RR_ctl00_lst_oPanelTittle span.txtT")
          unless nome
            nome = selector.fetch("div#ctl00_C1_RR_ctl00_lst_oPanelTittle span.txtTitleBlack")
          end
          unless nome
            nome = selector.fetch("div#ctl00_C1_RR_ctl00_lst_oPanelTittle a.txtT")
          end

          endereco = selector.fetch("div#ctl00_C1_RR_ctl00_lst_oPanelTitleCat+div div.divAddress>span.CmpInf")
          bairro = selector.fetch("div#ctl00_C1_RR_ctl00_lst_oPanelTitleCat+div div.divNeighborHood>span.CmpInf")
          cep = selector.fetch("div#ctl00_C1_RR_ctl00_lst_oPanelTitleCat+div div.divCEP>span.CmpInf")
          categoria = selector.fetch("div#ctl00_C1_RR_ctl00_lst_oPanelCategory>span.CmpInf")
        end
      rescue TimeoutError
        raise GuiaMaisException.new, 'GuiaMais fora do ar'
      end
      return Cliente.new(nome, endereco, bairro, cep, categoria)
    end
  end
end

if __FILE__ == $0
  cliente = GuiaMais::Minerador.iniciar(32325151, :estado => :piaui)
  p cliente
end
