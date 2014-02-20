require 'spec_helper'


# Things that need to be considered:
#
# Conversion of underscored to camelCase?
#
# * double vs triple slash
#
#   {{foo}} vs  {{{foo}}}
#
# * block expressions
#   {{#if cond}}
#   {{else}}
#   {{/end}}
#
# * paths and 'this' reference
#
#   {{foo.bar}}
#   {{../derp}}
#
#   {{./name}} == {{this/name}} == {{this.name}}
#
# * iterator methods
#
#   {{@first}}, {{@last}}, {{@index}}, {{@key}}



describe ThirdRail::Handlebars::Binding do
  def render(template)

    _buffer_name = '@_third_rail_output_buffer'

    Tilt::ErubisTemplate.new(outvar: _buffer_name) { template }.render(described_class.new(outvar: _buffer_name))
  end

  # it "converts under_scored references to camelCase"

  it "renders double-slashed expressions" do
    template = '<div><%= expression %></div>'
    output   = '<div>{{expression}}</div>'

    expect(render(template)).to eql output
  end

  # it "renders triple-slashed expressions" do
  #   template = Tilt::ERBTemplate.new { '<div><%= expression! %></div>' }
  #   output   = '<div>{{{expression}}}</div>'

  #   expect(template.render(subject)).to eql output
  # end

  context "when rendering helper methods" do
    it "renders the complete expression" do
      template = '<div><%= helper arg1, arg2 %></div>'
      output   = '<div>{{helper arg1 arg2}}</div>'

      expect(render(template)).to eql output
    end

    it "correctly formats any literals passed as arguments" do
      template = '<div><%= helper arg1, "string-literal", 42, arg2 %></div>'
      output   = '<div>{{helper arg1 "string-literal" 42 arg2}}</div>'

      expect(render(template)).to eql output
    end
  end

  it "renders block expressions" do
    template = "<div><% list(people) do %><%= firstName %><% end %></div>"
    output   = "<div>{{#list people}}{{firstName}}{{/list}}</div>"

    expect(render(template)).to eql output
  end


  # it "renders block expressions with reserved Ruby words"

  # it "resolves paths"
  #   # recursively detect chained calls??



  # # {{#each articles.[10].[#comments]}}
  # it "resolves expressions with segment-literal"


  # it "resolves the 'this' reference according to a preference"

  # it "renders iterator methods"
  #   # block variable that prefixes first/etc with @ ?





end