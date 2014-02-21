module ThirdRail::Handlebars
  class Binding
    attr_reader :__args

    def initialize(**args)
      @__args = args

      # set up our Tilt output buffer
      instance_variable_set(__args[:outvar], "")
    end

    # `method_missing` should only handle two things:
    #  - converting token -> expression (including any arguments passed)
    #  - injecting content for block calls back into the calling context
    #
    # Everything else can (and should) be handled by Expression.
    def method_missing(token, *args, &block)

      # We've been passed a block, so evaluate it in the context of a new binding,
      # thus ensuring we capture it for injection in the proper order of things
      if block_given?
        __buffer << Expression.new(token, *args).to_s { __rebind(block) }

      # special case; has been called in the context of a block with a non-output
      # node; inject it into the current buffer
      elsif token == :else
        __buffer << Expression.new(token, *args)

      # default case: called from an output block, ergo we can just return
      # something that responds to to_str
      else
        Expression.new(token, *args)
      end
    end

    # Return self for any tokens that map to Ruby keywords (if, else, unless)
    def __hb
      self
    end

    # Because Tilt injects a local variable named 'this' into our binding,
    # we need this as a work-around for self-reference bindings
    def _this
      Expression.new(:this)
    end

    # # A special case; because this shouldn't be called as an output, we need to inject
    # # it directly into our output buffer
    # def _else
    #   __buffer << Expression.new(:else)
    # end

    private

    def __buffer
      instance_variable_get(__args[:outvar])
    end

    def __rebind(blk)
      self.class.new(__args).instance_eval(&blk)
    end
  end
end
