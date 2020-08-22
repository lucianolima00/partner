require 'rails_helper'

RSpec.describe PartnerForm, type: :model do
  subject do
    described_class.new(diaper_bank_id: Faker::Number.number)
  end
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a diaper_bank_id" do
    subject.diaper_bank_id = nil
    expect(subject).to_not be_valid
  end
end
