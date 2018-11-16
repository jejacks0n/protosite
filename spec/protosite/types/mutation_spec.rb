require "spec_helper"

describe Protosite::Types::Mutation do
  subject { described_class }

  it { is_expected.to have_field(:create_user).with_mutation(Protosite::Mutations::CreateUser) }
  it { is_expected.to have_field(:update_current_user).with_mutation(Protosite::Mutations::UpdateCurrentUser) }

  it { is_expected.to have_field(:create_page).with_mutation(Protosite::Mutations::CreatePage) }
  it { is_expected.to have_field(:update_page).with_mutation(Protosite::Mutations::UpdatePage) }
  it { is_expected.to have_field(:remove_page).with_mutation(Protosite::Mutations::RemovePage) }
  it { is_expected.to have_field(:publish_page).with_mutation(Protosite::Mutations::PublishPage) }
end
