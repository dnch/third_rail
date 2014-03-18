module ThirdRail::Handlebars
  class Transpiler

    attr_reader :template_format

    def initialize(path)
      @path = (path.is_a? Pathname) ? path : Pathname.new(path)

      # extname returns the dot; strip it.
      @template_format = @path.extname.slice(1..-1).to_sym
    end
  end
end
