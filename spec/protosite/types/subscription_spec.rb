require "spec_helper"

describe Protosite::Types::Subscription do
  subject { described_class }

  it { is_expected.to have_field(:notification).of_type("Notification") }

  it { is_expected.to have_field(:user_created).of_type("User") }
  it { is_expected.to have_field(:user_updated).of_type("User").with_args(:id) }

  it { is_expected.to have_field(:page_created).of_type("Page") }
  it { is_expected.to have_field(:page_removed).of_type("Page") }
  it { is_expected.to have_field(:page_updated).of_type("Page") }
end
