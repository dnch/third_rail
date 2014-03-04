module ThirdRail::Handlebars
  class HamlBinding < Binding
    private

    def __buffer
      haml_buffer.buffer
    end
  end
end
