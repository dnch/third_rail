module ThirdRail::Handlebars
  class Expression

    attr_reader :literal

    def initialize(literal)
      @literal = literal.to_s
    end

    def to_s
      "{{" << literal << "}}"
    end
  end
end
