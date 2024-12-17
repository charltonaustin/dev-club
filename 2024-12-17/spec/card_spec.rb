require_relative "./spec_helper"
require_relative "../src/card"

# nZOMBIES
#
# nil :check:
# Zero
# One :check:
# Many
# Boundaries
# Interface
# Exception
# Simple :check:

describe Card do
  describe "attributes" do
    context "state based" do
      context "nil" do
        let(:card) { Card.new(nil, nil)}

        it "sets suit" do
          card = Card.new(nil, nil)

          expect(card.suit).to eq(nil)
        end

        it "sets value" do
          card = Card.new(nil, nil)

          expect(card.value).to eq(nil)
        end
      end
    end
  end

  describe "#to_s" do
    context "functional based" do
      it "handles nil" do
        card = Card.new(nil, nil)

        expect(card.to_s).to eq(" of ")
      end
    end
  end
end
