# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "guia_mais"
  s.version = "0.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Claudemiro Alves Feitosa Neto"]
  s.date = "2012-05-15"
  s.description = "Busca dados no site Guia Mais atrav\xC3\xA9s do telefone"
  s.email = "dimiro1@gmail.com"
  s.extra_rdoc_files = ["README", "lib/guia_mais.rb"]
  s.files = ["README", "Rakefile", "lib/guia_mais.rb", "test/guia_mais_test.rb", "Manifest", "guia_mais.gemspec"]
  s.homepage = "https://github.com/dimiro1/guia_mais"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Guia_mais", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "guia_mais"
  s.rubygems_version = "1.8.23"
  s.summary = "Busca dados no site Guia Mais atrav\xC3\xA9s do telefone"
  s.test_files = ["test/guia_mais_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<htmlentities>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<htmlentities>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<htmlentities>, [">= 0"])
  end
end
