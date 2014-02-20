module ThirdRail::Handlebars
  class Expression

    attr_reader :literal, :args, :options, :block

    # # use when calling chained expressions from binding
    # def method_missing(token)
    #   array_of_pre_called_literals << token
    #   self
    # end

    def initialize(literal, *args, **options)
      @literal = literal.to_s
      @args    = args
      @options = options
    end

    def to_literal
      literal
    end

    def to_s(&block)
      String.new.tap do |s|
        s << "{{"
        s << "#" if block_given?
        s << literal

        unless args.empty?
          s << " "
          s << args.map { |a| escape_arg(a) }.join(" ")
        end

        s << "}}"

        if block_given?
          s << yield
          s << "{{"
          s << "/"
          s << literal
          s << "}}"
        end
      end
    end

    private

    def escape_arg(arg)
      case arg
      when Expression                     then arg.literal
      when String                         then "\"#{arg}\""
      when Numeric, TrueClass, FalseClass then arg.to_s
      when NilClass                       then "null"
      end
    end



  end
end
