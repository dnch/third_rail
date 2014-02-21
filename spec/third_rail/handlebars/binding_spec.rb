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

  # for the sake of clarity (and dealing with the odd behavior of ERB)
  # strip any whitespace that occurs between tokens
  def strip_whitespace(str)
    str.gsub /([>}])\s+([<{])/, '\1\2'
  end

  # build a template and render it.
  def render(str)
    buffer_name = '@_third_rail_output_buffer'

    template = Tilt::ErubisTemplate.new(outvar: buffer_name, trim: true) { str }
    output   = template.render(described_class.new(outvar: buffer_name))

    strip_whitespace(output)
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
    template = <<-TMPL.strip_heredoc
      <div>
        <% each(people) do %>
          <%= firstName %>
        <% end %>
      </div>
    TMPL

    output = <<-OTPT.strip_heredoc
      <div>
        {{#each people}}
          {{firstName}}
        {{/each}}
      </div>
    OTPT

    expect(render(template)).to eql strip_whitespace(output)
  end

  it "renders block expressions with an else condition" do
    template = <<-TMPL.strip_heredoc
      <div>
        <% list(people) do %>
          <%= firstName %>
        <% __hb.else %>
          <%= lastName %>
        <% end %>
      </div>
    TMPL

    output = <<-OTPT.strip_heredoc
      <div>
        {{#list people}}
          {{firstName}}
        {{else}}
          {{lastName}}
        {{/list}}
      </div>
    OTPT

    expect(render(template)).to eql strip_whitespace(output)
  end

  # Keep in mind that handlebars doesn't actually allow full expressions
  # for if / unless blocks, so we can get away with this sort of sneaky shit
  it "renders block expressions that map to ruby keywords" do
    template = <<-TMPL.strip_heredoc
      <div>
        <% __hb.if(people) do %>
          <%= firstName %>
        <% __hb.else %>
          <%= lastName %>
        <% end %>

        <% __hb.unless(people) do %>
          <%= firstName %>
        <% __hb.else %>
          <%= lastName %>
        <% end %>
      </div>
    TMPL

    output = <<-OTPT.strip_heredoc
      <div>
        {{#if people}}
          {{firstName}}
        {{else}}
          {{lastName}}
        {{/if}}

        {{#unless people}}
          {{firstName}}
        {{else}}
          {{lastName}}
        {{/unless}}
      </div>
    OTPT

    expect(render(template)).to eql strip_whitespace(output)
  end

  it "renders chained expressions" do
    template = "<div><%= author.firstName %></div>"
    output   = "<div>{{author.firstName}}</div>"

    expect(render(template)).to eql output
  end

  it "renders scope-resolution expressions" do
    template = "<div><%= _this.firstName %></div>"
    output   = "<div>{{this.firstName}}</div>"

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