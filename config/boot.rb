root = File.dirname(__FILE__) + "/.."
$LOAD_PATH.unshift(root)

require_relative 'initializers/active_record'
Dir[File.join('orm', '*.rb')].sort.each { |file| require file }
require 'infra'
