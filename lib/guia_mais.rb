# -*- coding: utf-8 -*-
require "rubygems"
require "httparty"
require "hpricot"
require "timeout"

class String
  def to_utf8
    unpack("C*").pack("U*")
  end
end

module GuiaMais
  class GuiaMaisException < Exception
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

  class Minerador
    include HTTParty
    base_uri "http://www.guiamais.com.br"
    @@pagina = ""

    def self.buscar(oque, query = {})
      query[:txb] = oque
      query[:nes] ||= ESTADOS[query[:estado]][:sigla] if query[:estado]
      query[:ies] ||= ESTADOS[query[:estado]][:guia] if query[:estado]
      query.delete(:estado)
      resultado = get("/Results.aspx", :query => query)
      @@pagina = Hpricot(resultado.body.to_utf8)
      minerar_dados
    end

    private
    def self.buscar_elemento(elemento)
      resultado = @@pagina.search(elemento).first
      resultado ? resultado.inner_html : nil
    end
    
    def self.minerar_dados
      nome, endereco, bairro, cep, categoria = nil
      begin
        timeout(10) do
          nome = buscar_elemento("div#ctl00_C1_RR_ctl00_lst_oPanelTittle span.txtT")
          unless nome
            nome = buscar_elemento("div#ctl00_C1_RR_ctl00_lst_oPanelTittle span.txtTitleBlack")
          end
          unless nome
            nome = buscar_elemento("div#ctl00_C1_RR_ctl00_lst_oPanelTittle a.txtT")
          end

          endereco = buscar_elemento("div#ctl00_C1_RR_ctl00_lst_oPanelTitleCat+div div.divAddress>span.CmpInf")
          bairro = buscar_elemento("div#ctl00_C1_RR_ctl00_lst_oPanelTitleCat+div div.divNeighborHood>span.CmpInf")
          cep = buscar_elemento("div#ctl00_C1_RR_ctl00_lst_oPanelTitleCat+div div.divCEP>span.CmpInf")
          categoria = buscar_elemento("div#ctl00_C1_RR_ctl00_lst_oPanelCategory>span.CmpInf")
        end
      rescue TimeoutError
        raise GuiaMaisException.new, 'GuiaMais fora do ar'
      end
      return Cliente.new(nome, endereco, bairro, cep, categoria)
    end

  end
end
