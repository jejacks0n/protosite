require "spec_helper"

describe Protosite::AuthFailure do
  it "generates a 401 response that will prompt for login" do
    status, headers, response = Protosite::AuthFailure.call({})

    expect(status).to eq 401
    expect(headers["WWW-Authenticate"]).to eq "Basic"
    expect(headers["Content-Type"]).to eq "application/json; charset=utf-8"
    expect(response.body).to eq %{{"errors":"that action requires that you authenticate first"}}
  end
end
