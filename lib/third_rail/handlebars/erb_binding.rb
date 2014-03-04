module ThirdRail::Handlebars
  class ERBBinding < Binding
    def initialize(**args)
      super(args)

      instance_variable_set(__args[:outvar] || "@_third_rail_output_buffer", "")
    end

    private

    def __buffer
      instance_variable_get(__args[:outvar])
    end

  end
end
