#!/usr/bin/env rake
require 'rspec/core/rake_task'
require 'foodcritic'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      context: true,
      fail_tags: ['~FC043'],
      exclude_paths: ['spec/', 'test/']
    }
  end
end

desc 'Run all style checks'
task :style => %w( style:chef )

# Rspec and ChefSpec
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

task :travis => %w( style:chef spec )

task :test => %w( style:chef spec )
