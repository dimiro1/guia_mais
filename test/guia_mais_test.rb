# -*- coding: utf-8 -*-
require "#{Dir.pwd}/lib/guia_mais.rb"
require "test/unit"

class GuiaMaisTest < Test::Unit::TestCase
  def test_se_funciona_com_32222222_RN
    cliente = GuiaMais::Cliente.buscar("32222222", :estado => :rio_grande_do_norte)
    assert_equal cliente.nome, "MED DIET DROGARIA"
    assert_equal cliente.endereco, "Av Afonso Pena 939 "
    assert_equal cliente.bairro, "Tirol"
    assert_equal cliente.cep, "59020-100"
    assert_equal cliente.categoria, "Farmácias e Drogarias - Art"
  end

  def test_se_funciona_com_32222222_PI
    cliente = GuiaMais::Cliente.buscar("32222222", :estado => :piaui)
    assert_equal cliente.nome, "RÁDIO TÁXI"
    assert_equal cliente.endereco, "R Álvaro Ferreira, 60"
    assert_equal cliente.bairro, "Monte Castelo"
    assert_equal cliente.cep, "64017-380"
    assert_equal cliente.categoria, "Táxi"
  end

  def test_se_funciona_com_32222222_AP
    cliente = GuiaMais::Cliente.buscar("32222222", :estado => :amapa)
    assert_equal cliente.nome, "ELDORADO VEÍCULOS"
    assert_equal cliente.endereco, "Rod Br-156 km 3 Boné Azul"
    assert_equal cliente.bairro, "Lotm Açaí"
    assert_equal cliente.cep, "68900-001"
    assert_equal cliente.categoria, "Automóveis - Agências e Revendedores"
  end

  def test_se_funciona_com_32325151_PI
    cliente = GuiaMais::Cliente.buscar("32325151", :estado => :piaui)
    assert_equal cliente.nome, "ARTTE DOS PÉS"
    assert_equal cliente.endereco, "Av Dom Severino, 1065"
    assert_equal cliente.bairro, "Fátima"
    assert_equal cliente.cep, "64049-370"
    assert_equal cliente.categoria, "Cabeleireiros e Institutos de Beleza"
  end

  def test_se_funciona_com_32321311_PI
    cliente = GuiaMais::Cliente.buscar("32331128", :estado => :piaui)
    assert_equal cliente.nome, "ALEMANHA VEICULOS"
    assert_equal cliente.endereco, "Av João XXIII 3480 "
    assert_equal cliente.bairro, "Noivos"
    assert_equal cliente.cep, "64045-000"
    assert_equal cliente.categoria, "Automóveis - Concessionárias e Serviços Autorizados"
  end

end
