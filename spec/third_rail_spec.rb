require 'spec_helper'

describe ThirdRail do
  it "does a thing" do
    expect(true).to be true
  end

  it "does more things" do

    template = Tilt::ERBTemplate.new { 'String? <%= derp %>! More?? <%= derp! %>' }
    binding = ThirdRail::HandlebarsProxyBinding.new

    expect(template.render(binding)).to eql 'String? {{derp}}! More?? {{{derp}}}'



  end
end
