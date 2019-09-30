# frozen_string_literal: true

RSpec.describe DNPedia::API, :vcr do
  subject { described_class.new }

  describe "#search" do
    it do
      res = subject.search("~%docomo%")
      expect(res).to be_a(Hash)
    end

    context "when given other params" do
      it do
        res = subject.search("%docomo%", days: 7, rows: 200)
        expect(res).to be_a(Hash)
      end

      it do
        res = subject.search("%docomo%", mode: "deleted", days: 7, rows: 200)
        expect(res).to be_a(Hash)
      end
    end
  end
end
