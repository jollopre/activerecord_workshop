module ORM
  class UuidType < ActiveModel::Type::Binary
    UUID_PATTERN = /^\h{8}-\h{4}-\h{4}-\h{4}-\h{12}$/.freeze
    DECODED_PATTERN = /^(\h{8})(\h{4})(\h{4})(\h{4})(\h{12})$/.freeze

    def type
      :uuid
    end

    def cast(value)
      super
    end

    def deserialize(value)
      if value.is_a?(String) && value.encoding == Encoding::ASCII_8BIT
        decoded_value = decode(value)
        add_dashes(decoded_value)
      else
        super
      end
    end

    def serialize(value)
      if value.is_a?(String) && value.match?(UUID_PATTERN)
        Data.new(remove_dashes(value))
      else
        super
      end
    end

    class Data < ActiveModel::Type::Binary::Data
      def initialize(value)
        @value = value
      end

      def hex
        @value
      end
    end

    private

    def remove_dashes(value)
      value.delete("-")
    end

    def add_dashes(value)
      value.gsub(DECODED_PATTERN, '\1-\2-\3-\4-\5')
    end

    def decode(value)
      value.unpack1("H*")
    end
  end
end
