Gem::Specification.new do |s|
  s.name = %q{k-way-merge}
  s.version = "0.1.0"

  s.add_dependency 'builder'
  s.add_dependency 'pqueue'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'ruby-deug'

  s.authors = ["Instructure"]
  s.date = %q{2013-01-31}
  s.extra_rdoc_files = %W(LICENSE)
  s.files = %W(
          Changelog
          LICENSE
          README.md
          lib/kway_merge.rb
          k-way-merge.gemspec
  )
  s.homepage = %q{http://github.com/instructure/k-way-merge}
  s.require_paths = %W(lib)
  s.summary = %q{Ruby implementation of [K-Way Merge algorithm](...) with support for streaming evaluation.}
end
