require_relative 'lib/sidekiq/throttled_worker/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-throttled-worker"
  spec.version       = Sidekiq::ThrottledWorker::VERSION
  spec.authors       = ["xuxiangyang"]
  spec.email         = ["xxy@xuxiangyang.com"]

  spec.summary       = "Sidekiq concurrency limit per worker"
  spec.description   = "Sidekiq concurrency limit per worker"
  spec.homepage      = "https://github.com/xuxiangyang/sidekiq-throttled-worker"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/xuxiangyang/sidekiq-throttled-worker"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sidekiq"
end
