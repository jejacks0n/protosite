require "spec_helper"

describe Protosite::Types::Query do
  subject { described_class }

  it { is_expected.to have_field(:current_user).of_type("User") }

  it { is_expected.to have_field(:pages).of_type("[Page!]") }
  it { is_expected.to have_field(:page).of_type("Page").with_args(:id) }
end
