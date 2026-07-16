# frozen_string_literal: true

RSpec.describe InstacartApi::PersistedQueries do
  describe ".hash_for" do
    it "returns the persisted-query hash for a known operation" do
      expect(described_class.hash_for("Items")).to eq(
        "9ad66078d7fa81276b6bd4eb6a6f6fcdd1f4022ff0c3f5b4663c62877f06692a"
      )
    end

    it "raises for an unknown operation" do
      expect { described_class.hash_for("Nope") }.
        to raise_error(InstacartApi::UnknownOperationError, /Nope/)
    end
  end
end
