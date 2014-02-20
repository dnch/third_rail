module ThirdRail::Handlebars
  class Binding
    attr_reader :__args

    def initialize(**args)
      @__args = args

      instance_variable_set(__args[:outvar], "")
    end

    # this should only handle two things:
    #   - converting token -> expression (including any arguments passed)
    #   - injecting content for block calls back into the calling context
    #
    # Everything else can (and should) be handled by Expression
    def method_missing(token, *args, &block)

      # We've been passed a block, so evaluate it in the context of a new binding,
      # thus ensuring we capture it for injection in the proper order of things
      if block_given?
        __buffer << Expression.new(token, *args).to_s { __rebind(block) }
      else
        Expression.new(token, *args)
      end
    end

    private

    def __buffer
      instance_variable_get(__args[:outvar])
    end

    def __rebind(blk)
      self.class.new(__args).instance_eval(&blk)
    end
  end
end
