module ThirdRail::Handlebars
  class Expression

    attr_reader :tokens, :args, :options, :block

    def initialize(first_token, *args)
      @tokens  = [first_token.to_s.gsub(/^#{ThirdRail::Handlebars.keyword_prefix}/, '')]
      @args    = args
    end

    def method_missing(token)
      tokens << token.to_s
      self
    end

    def [](arg_token)
      tokens << case arg_token
      when Symbol  then "[##{arg_token}]"
      when String  then "[\"#{arg_token}\"]"
      when Numeric then "[#{arg_token}]"
      end

      self
    end

    def to_literal
      tokens.first
    end

    def to_str(&block)
      String.new.tap do |str|
        str << "{{"
        str << "#" if block_given?
        str << tokens.join(".")

        unless args.empty?
          str << " "
          str << args.map { |a| escape_arg(a) }.join(" ")
        end

        str << "}}"

        if block_given?
          str << yield
          str << "{{"
          str << "/"
          str << tokens.join(".")
          str << "}}"
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
