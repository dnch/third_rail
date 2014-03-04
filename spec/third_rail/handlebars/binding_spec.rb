require 'spec_helper'
require 'haml'
require 'pathname'
require 'active_support'
require 'action_view'

describe ThirdRail::Handlebars::Binding do

  # Build a template. Render it. Return an instance of Capybara::Node::Simple
  # so we can be more declarative about what we're looking for rather than
  # doing simple string comparisons
  def render(template_name, template_type)

    buffer_name = '@_third_rail_output_buffer'

    template_base_path = Pathname.new(__dir__).join("../../fixtures/templates")

    binding_class, template_class = case template_type
    when :erb then  [ThirdRail::Handlebars::ERBBinding, Tilt::ErubisTemplate]
    when :haml then [ThirdRail::Handlebars::HamlBinding, Tilt::HamlTemplate]
    end

    template_path = template_base_path.join("#{template_name}.#{template_type}")

    template = template_class.new(template_path, outvar: buffer_name)
    binding  = binding_class.new(outvar: buffer_name)
    output   = template.render(binding)

    Capybara.string(output)
  end

  # sugarsweet
  def within(scope)
    yield subject.find(scope)
  end

  context "when rendering simple expressions" do
    shared_examples "simple expression outputs" do |format|

      subject { render 'expressions', format }

      it "renders double-braced expressions" do
        expect(subject.find('#double-brace')).to have_text('{{expression}}')
      end

      it "renders helper expressions" do
        expect(subject.find('#helper-expression')).to have_text('{{helper arg1 arg2}}')
      end

      it "renders argument literals" do
        expect(subject.find('#argument-literal')).to have_text('{{helper arg1 "string-literal" 42 arg2}}')
      end

      it "renders chain exprssions" do
        expect(subject.find('#chain-expressions')).to have_text('{{author.firstName}}')
      end

      it "renders scope-resolution expressions" do
        expect(subject.find('#scope-expressions')).to have_text('{{this.firstName}}')
      end
    end

    it_should_behave_like "simple expression outputs", :erb
    it_should_behave_like "simple expression outputs", :haml
  end

  context "when rendering block expressions" do
    shared_examples "block expression outputs" do |format|

      subject { render 'blocks', format }

      it "renders simple block expressions" do
        expect(subject).to have_css('ul#each-block li')

        within('ul#each-block') do |ul|
          expect(ul).to have_text('{{#each people}}')
          expect(ul).to have_text('{{/each}}')
        end

        within('ul#each-block li') do |li|
          expect(li).to have_text('{{firstName}}')
        end
      end

    end

    it_should_behave_like "block expression outputs", :erb
    it_should_behave_like "block expression outputs", :haml
  end
end