$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'mocha'
require 'fakeweb'
require 'read_it_later'

RSpec.configure do |config|
  config.mock_with :mocha
end
