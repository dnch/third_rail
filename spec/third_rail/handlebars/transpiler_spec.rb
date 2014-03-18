require 'spec_helper'
require 'pathname'

describe ThirdRail::Handlebars::Transpiler do
  shared_examples "the transpiler" do |format|
    subject do
      described_class.new Pathname.new(__dir__).join("../../fixtures/templates/transpiler.#{format}")
    end

    it "knows the format of the template" do
      expect(subject.template_format).to eql format
    end
  end

  it_should_behave_like "the transpiler", :erb
  it_should_behave_like "the transpiler", :haml
end