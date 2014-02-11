module ThirdRail::Handlebars
  class Binding < BasicObject

    def method_missing(token, *args, &block)
      if args.empty?
        Expression.new(token)
      else
        Expression.new(token.to_s + " " + args.map { |e| e.is_a?(Expression) ? e.literal : e }.join(" "))
      end
    end

    private

  end
end
