module Infra
  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
