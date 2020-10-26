RSpec.describe Sidekiq::Throttled::Worker do
  it "has a version number" do
    expect(Sidekiq::Throttled::Worker::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
