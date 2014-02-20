require 'spec_helper'

describe ThirdRail::Handlebars::Expression do

  context "without any arguments" do
    it "builds double-slashed expressions" do
      expect(described_class.new(:token).to_s).to eql "{{token}}"
    end

    it "can be coerced into a literal representation" do
      expect(described_class.new(:token).to_literal).to eql "token"
    end

    it "builds triple-slashed expressions"
    it "converts under_scored references to camelCase"
  end

  context "when given a list of arguments" do
    it "wraps string arguments in double-quotes" do
      expect(described_class.new(:token, "option").to_s).to eql '{{token "option"}}'
    end

    it "does not wrap or escape numeric arguments" do
      expect(described_class.new(:token, 42).to_s).to eql "{{token 42}}"
    end

    it "does not escape true or false literals" do
      expect(described_class.new(:token, true).to_s).to eql "{{token true}}"
      expect(described_class.new(:token, false).to_s).to eql "{{token false}}"
    end

    it "transliterates nil into null" do
      expect(described_class.new(:token, nil).to_s).to eql "{{token null}}"
    end

    it "converts expressions passed as arguments to literals" do
      _arg = described_class.new(:arg)
      expect(described_class.new(:token, _arg).to_s).to eql "{{token arg}}"
    end

    it "concatenates the argument list with a single space character" do
      _args = [42, true, "argument", described_class.new(:arg)]
      expect(described_class.new(:token, *_args).to_s).to eql '{{token 42 true "argument" arg}}'
    end
  end

  context "when passed a block" do
    it "returns a correctly formatted block expression with the result of the block" do
      input = described_class.new(:list).to_s { "..." }
      output = "{{#list}}...{{/list}}"
      expect(input.to_s).to eql output
    end

    it "it returns a block expression including arguments" do
      input = described_class.new(:list, 42).to_s { "..." }
      output = "{{#list 42}}...{{/list}}"
    end
  end







  # it "can be a block-opener" do
  #   expect(described_class.new(:token, block_opener: true)).to eql "{{#token}}"
  # end

  # it "can be a block-closer" do
  #   expect(described_class.new(:token, block_closer: true)).to eql "{{/token}}"
  # end
end
