# -*- coding: utf-8 -*-
require "#{Dir.pwd}/lib/guia_mais.rb"
require "test/unit"

class GuiaMaisTest < Test::Unit::TestCase
  def test_se_funciona_com_32222222_RN
    cliente = GuiaMais::Cliente.buscar("32222222", :estado => :rio_grande_do_norte)
    #p cliente
    assert_equal "MED DIET DROGARIA", cliente.nome
    assert_equal "Av Afonso Pena 939 ", cliente.endereco
    assert_equal "Tirol", cliente.bairro
    assert_equal "59020-100", cliente.cep
    assert_equal "Farmácias e Drogarias", cliente.categoria
  end

  def test_se_funciona_com_32222222_PI
    cliente = GuiaMais::Cliente.buscar("32222222", :estado => :piaui)
    assert_equal "COOTAC - COOPERATIVA MISTA CONDUTORES AUTON VEÍCULOS PASSAGE", cliente.nome
    assert_equal "R Álvaro Ferreira 60 ", cliente.endereco
    assert_equal "Monte Castelo", cliente.bairro
    assert_equal "64017-380", cliente.cep
    assert_equal "Táxi", cliente.categoria
  end

  def test_se_funciona_com_32222222_AP
    cliente = GuiaMais::Cliente.buscar("32222222", :estado => :amapa)
    assert_equal "ELDORADO VEÍCULOS E PEÇAS", cliente.nome
    assert_equal "Rod BR-156  km 3", cliente.endereco
    assert_equal "Jardim Felicidade", cliente.bairro
    assert_equal "68909-094", cliente.cep
    assert_equal "Automóveis - Concessionárias e Serviços Autorizados", cliente.categoria
  end

  def test_se_funciona_com_32325151_PI
    cliente = GuiaMais::Cliente.buscar("32325151", :estado => :piaui)
    assert_equal "ARTTE DOS PÉS", cliente.nome
    assert_equal "Av Elias João Tajra, 1684", cliente.endereco
    assert_equal "Jóquei", cliente.bairro
    assert_equal "64049-300", cliente.cep
    assert_equal "Clínicas de Estética", cliente.categoria
  end

  def test_se_funciona_com_32321311_PI
    cliente = GuiaMais::Cliente.buscar("21071311", :estado => :piaui)
    assert_equal "ALEMANHA VEÍCULOS", cliente.nome
    assert_equal "Av João XXIII 3480 ", cliente.endereco
    assert_equal "Noivos", cliente.bairro
    assert_equal "64045-000", cliente.cep
    assert_equal "Automóveis - Agências e Revendedores", cliente.categoria
  end

end
