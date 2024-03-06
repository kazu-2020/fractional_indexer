# frozen_string_literal: true

RSpec.describe FractionalIndexer::Configuration do
  describe "#digits" do
    subject { described_class.new.digits }

    it { is_expected.to eq((described_class::DIGITS_LIST[:base_62]).to_a) }

    context "when change base to 10" do
      it "returns base 10 digits" do
        config = described_class.new
        config.base = :base_10

        expect(config.digits).to eq((described_class::DIGITS_LIST[:base_10]).to_a)
      end
    end

    context "when change base to 94" do
      it "returns base 94 digits" do
        config = described_class.new
        config.base = :base_94

        expect(config.digits).to eq((described_class::DIGITS_LIST[:base_94]).to_a)
      end
    end

    context "when change base to invalid value" do
      it "returns base 62 digits" do
        config = described_class.new
        config.base = :base_100

        expect(config.digits).to eq((described_class::DIGITS_LIST[:base_62]).to_a)
      end
    end
  end
end
