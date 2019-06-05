Gem::Specification.new do |s|
  s.name = 'conflisp'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'A tool for buliding JSON-serializable lisps.'
  s.homepage = 'https://github.com/everwise/conflisp'
  s.authors = ['Rocky Meza']
  s.email = ['rocky@geteverwise.com']

  s.files = [
    'lib/conflisp.rb',
    *Dir['lib/conflisp/*.rb']
  ]

  s.add_development_dependency 'rspec', '~> 3.7.0'
end
