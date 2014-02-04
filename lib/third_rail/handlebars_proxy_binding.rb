module ThirdRail
  class HandlebarsProxyBinding < BasicObject
    def method_missing(name)
      name =~ /!$/ ? "{{{#{name.to_s.sub('!', '')}}}}" : "{{#{name}}}"
    end
  end
end