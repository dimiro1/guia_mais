# -*- coding: utf-8 -*-
require "../lib/guia_mais"
require "test/unit"

class GuiaMaisTest < Test::Unit::TestCase
  def test_se_funciona_com_32222222_RN
    cliente = GuiaMais::Minerador.buscar("32222222", :estado => :rio_grande_do_norte)
    assert_equal cliente.nome, "MED DIET DROGARIA"
    assert_equal cliente.endereco, "AVENIDA AFONSO PENA 939 "
    assert_equal cliente.bairro, "TIROL"
    assert_equal cliente.cep, "59020-100"
    assert_equal cliente.categoria, "Farmácias e Drogarias - Art"
  end

  def test_se_funciona_com_32222222_PI
    cliente = GuiaMais::Minerador.buscar("32222222", :estado => :piaui)
    assert_equal cliente.nome, "RÁDIO TAXI"
    assert_equal cliente.endereco, "R Álvaro Ferreira, 60 Monte Castelo"
    assert_equal cliente.bairro, "Monte Castelo"
    assert_equal cliente.cep, "64017-380"
    assert_equal cliente.categoria, "Táxi"
  end

  def test_se_funciona_com_32222222_AP
    cliente = GuiaMais::Minerador.buscar("32222222", :estado => :amapa)
    assert_equal cliente.nome, "ELDORADO VEÍCULOS"
    assert_equal cliente.endereco, "Rod Br-156 km 3 Boné Azul"
    assert_equal cliente.bairro, "Lotm Açaí"
    assert_equal cliente.cep, "68900-001"
    assert_equal cliente.categoria, "Automóveis - Agências e Revendedores"
  end

  def test_se_funciona_com_32325151_PI
    cliente = GuiaMais::Minerador.buscar("32325151", :estado => :piaui)
    assert_equal cliente.nome, "ARTTE DOS PÉS"
    assert_equal cliente.endereco, "Av Dom Severino, 1065"
    assert_equal cliente.bairro, "Fátima"
    assert_equal cliente.cep, "64049-375"
    assert_equal cliente.categoria, "Cabeleireiros e Institutos de Beleza"
  end

  def test_se_funciona_com_32321311_PI
    cliente = GuiaMais::Minerador.buscar("32321311", :estado => :piaui)
    assert_equal cliente.nome, "ALEMANHA VEICULOS"
    assert_equal cliente.endereco, "AVENIDA JOAO XXIII 3480 "
    assert_equal cliente.bairro, "NOIVOS"
    assert_equal cliente.cep, "64045-000"
    assert_equal cliente.categoria, "Automóveis - Concessionárias e Serviços Autorizados"
  end

end
