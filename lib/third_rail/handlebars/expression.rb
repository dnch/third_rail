module ThirdRail::Handlebars
  class Expression

    attr_reader :tokens, :args, :options, :block

    # # use when calling chained expressions from binding
    # def method_missing(token)
    #   array_of_pre_called_literals << token
    #   self
    # end

    def initialize(first_token, *args)
      @tokens  = [first_token.to_s]
      @args    = args
    end

    def method_missing(token)
      tokens << token.to_s
      self
    end

    # def to_hash

    #   raise "Derp!"

    #   nil
    # end

    def to_literal
      tokens.first
    end

    def to_str(&block)
      String.new.tap do |s|
        s << "{{"
        s << "#" if block_given?
        s << tokens.join(".")

        unless args.empty?
          s << " "
          s << args.map { |a| escape_arg(a) }.join(" ")
        end

        s << "}}"

        if block_given?
          s << yield
          s << "{{"
          s << "/"
          s << tokens.join(".")
          s << "}}"
        end
      end
    end

    alias :to_s :to_str

    private

    def escape_arg(arg)
      case arg
      when Expression                     then arg.to_literal
      when String                         then "\"#{arg}\""
      when Numeric, TrueClass, FalseClass then arg.to_s
      when NilClass                       then "null"
      end
    end



  end
end
