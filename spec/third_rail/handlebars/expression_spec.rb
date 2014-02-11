require 'spec_helper'

describe ThirdRail::Handlebars::Expression do
  it "converts under_scored references to camelCase"

  it "builds double-slashed expressions" do
    expect(described_class.new(:token).to_s).to eql "{{token}}"
  end

  it "returns the literal" do
    expect(described_class.new(:token).literal).to eql "token"
  end

  it "builds triple-slashed expressions" do
  end
end
