# -*- coding: utf-8 -*-
require "rubygems"
require "httparty"
require "hpricot"
require "timeout"
require "htmlentities"
require "iconv"
require "cgi"

class String
  def to_utf8
    unpack("C*").pack("U*")
  end
end

module GuiaMais
  class GuiaMaisException < Exception
  end

  # We have to pass a valid UerAgent
  USER_AGENTS = [
                 "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)",
                 "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.14 (KHTML, like Gecko) Chrome/10.0.603.3 Safari/534.14",
                 "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; OfficeLiveConnector.1.3; OfficeLivePatch.0.0)",
                 "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0; FunWebProducts; BOIE9;PTBR)",
                 "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; GTB7.1; InfoPath.2; .NET CLR 2.0.50727; OfficeLiveConnector.1.3; OfficeLivePatch.0.0; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; BRI/2)",
                 "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.874.106 Safari/535.2",
                 "Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20100101 Firefox/7.0.1",
                 "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.26+ (KHTML, like Gecko) Version/5.0 Safari/534.26+",
                 "Opera/9.80 (X11; Linux x86_64; U; pt-BR) Presto/2.9.168 Version/11.51",
                 "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; pt-br) AppleWebKit/533.21.1 (KHTML, like Gecko) Safari/522.0",
                 "Mozilla/5.0 (X11; U; Linux i686; pt-br) AppleWebKit/531.2+ (KHTML, like Gecko) Version/5.0 Safari/531.2+",
                 "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)",
                 "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; pt-br) AppleWebKit/533.21.1 (KHTML, like Gecko)",
                 "Mozilla/5.0 (Windows NT 6.0; WOW64; rv:8.0) Gecko/20100101 Firefox/8.0",
                 "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)",
                 "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)",
                 "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; InfoPath.2; .NET4.0C; AskTbATU3/5.13.1.18107)",
                 "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; InfoPath.2)"
                ]

  ESTADOS = {
    :acre                => {:sigla => 'AC'},
    :alagoas             => {:sigla => 'AL'},
    :amazonas            => {:sigla => 'AM'},
    :amapa               => {:sigla => 'AP'},
    :bahia               => {:sigla => 'BA'},
    :ceara               => {:sigla => 'CE'},
    :distrito_federal    => {:sigla => 'DF'},
    :espirito_santo      => {:sigla => 'ES'},
    :goias               => {:sigla => 'GO'},
    :maranhao            => {:sigla => 'MA'},
    :minas_gerais        => {:sigla => 'MG'},
    :mato_grosso_do_sul  => {:sigla => 'MS'},
    :mato_grosso         => {:sigla => 'MT'},
    :para                => {:sigla => 'PA'},
    :paraiba             => {:sigla => 'PB'},
    :pernambuco          => {:sigla => 'PE'},
    :piaui               => {:sigla => 'PI'},
    :parana              => {:sigla => 'PR'},
    :rio_de_janeiro      => {:sigla => 'RJ'},
    :rio_grande_do_norte => {:sigla => 'RN'},
    :rondonia            => {:sigla => 'RO'},
    :roraima             => {:sigla => 'RR'},
    :rio_grande_do_sul   => {:sigla => 'RS'},
    :santa_catarina      => {:sigla => 'SC'},
    :sergipe             => {:sigla => 'SE'},
    :sao_paulo           => {:sigla => 'SP'},
    :tocantins           => {:sigla => 'TO'}
  }

  class Cliente
    attr_reader :nome, :telefone, :endereco, :bairro, :cep, :categoria
    def initialize(nome, telefone, endereco, bairro, cep, categoria)
      @nome = nome
      @telefone = telefone
      @endereco = endereco
      @bairro = bairro
      @cep = cep
      @categoria = categoria
    end

    def self.buscar(oque, params)
      Minerador.buscar(oque, params)
    end

  end

  class Minerador
    include HTTParty
    base_uri "http://www.guiamais.com.br"
    headers 'User-Agent' => USER_AGENTS.shuffle[0]
    @@pagina = ""
    @@oque = ""

    def self.buscar(oque, params = {})
      estado = ESTADOS[params[:estado]][:sigla] if params[:estado] || ""
      resultado = get("/busca/#{CGI.escapeHTML(oque)}-#{estado}")
      @@pagina = Hpricot(resultado.body.to_utf8)
      @@oque = oque
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
          nome = buscar_elemento("html/body/div[1]/div/div/div[3]/div[1]/div[1]/div[3]/div[2]/h2/a")
          endereco = buscar_elemento("html/body/div[1]/div/div/div[3]/div[1]/div[1]/div[3]/div[2]/p[1]")

          unless endereco.nil?
            cep = endereco.slice(endereco.index("CEP:"), endereco.length)
            cep = cep.slice(5, cep.index("<br"))
            cep = cep.slice(0, 9)

            endereco = endereco.slice(0, endereco.index("<br />"))

            bairro = endereco.slice(endereco.index(" - "), endereco.length)
            endereco = endereco.slice(0, endereco.index(" - "))
            bairro = bairro.slice(3, bairro.length)
          end
          categoria = buscar_elemento("html/body/div[1]/div/div/div[3]/div[1]/div[1]/div[3]/div[2]/p[2]/b")

          nome = HTMLEntities.new.decode(nome)
          endereco = HTMLEntities.new.decode(endereco)
          bairro = HTMLEntities.new.decode(bairro)
          categoria = Iconv.conv("ISO-8859-1", "UTF-8", categoria)
        end
      rescue TimeoutError
        raise GuiaMaisException.new, 'GuiaMais fora do ar'
      end
      return Cliente.new(nome, @@oque, endereco, bairro, cep, categoria)
    end

  end
end
