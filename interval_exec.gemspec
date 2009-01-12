# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{interval_exec}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Koski"]
  s.date = %q{2009-01-12}
  s.description = %q{Library to execute code at defined intervals -- useful in command-line scripts or daemons when a resource must be polled periodically.}
  s.email = ["ben@benkoski.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/interval_exec/interval_exec.rb", "lib/interval_exec.rb", "script/console", "script/destroy", "script/generate", "test/test_helper.rb", "test/test_interval_exec.rb"]
  s.has_rdoc = true
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{interval_exec}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Library to execute code at defined intervals -- useful in command-line scripts or daemons when a resource must be polled periodically.}
  s.test_files = ["test/test_helper.rb", "test/test_interval_exec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end

end
