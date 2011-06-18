# -*- encoding: utf-8 -*-
require File.expand_path("../lib/glitchy_gem/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "glitchy_gem"
  s.version     = GlitchyGem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["GlitchyApp"]
  s.email       = ["support@glitchygem.com"]
  s.homepage    = "http://rubygems.org/gems/glitchy_gem"
  s.summary     = "The gem to enable you to track your application errors with GlitchApp"
  s.description = "Track your application errors with GlitchyApp and search through them."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "glitchy_gem"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
