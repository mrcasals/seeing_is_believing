class SeeingIsBelieving
  class Binary
    class CommentFormatter
      def self.call(*args)
        new(*args).call
      end

      attr_accessor :line_length, :separator, :result, :options

      def initialize(line_length, separator, result, options)
       self.line_length = line_length
       self.separator   = separator
       self.result      = result.gsub "\n", '\n'
       self.options     = options
      end

      def call
        formatted = truncate "#{separator}#{result}", max_result_length
        formatted = "#{' '*padding_length}#{formatted}"
        formatted = truncate formatted, max_line_length
        formatted = '' unless formatted.sub(/^ */, '').start_with? separator
        formatted
      end

      private

      def max_line_length
        length = options.fetch(:max_line_length, Float::INFINITY) - line_length
        length = 0 if length < 0
        length
      end

      def max_result_length
        options.fetch :max_result_length, Float::INFINITY
      end

      def padding_length
        padding_length = options.fetch(:pad_to, 0) - line_length
        padding_length = 0 if padding_length < 0
        padding_length
      end

      def truncate(string, length)
        return string if string.size <= length
        ellipsify string.slice(0, length)
      end

      def ellipsify(string)
        string.sub(/.{0,3}$/) { |last_chars| last_chars.gsub /./, '.' }
      end
    end
  end
end
