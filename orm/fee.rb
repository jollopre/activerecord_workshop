module ORM
  class Fee
    attr_accessor :type, :value_unit_rate, :value

    def initialize(params = {})
      @type, @value_unit_rate, @value = params.values_at(:type, :value_unit_rate, :value)
    end

    class << self
      def load(serialized_fee)
        return unless serialized_fee

        new(
          JSON.parse(serialized_fee, symbolize_names: true)
        )
      end

      def dump(fee)
        fee&.to_json
      end
    end
  end
end
