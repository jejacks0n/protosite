def register_driver(name, args = [], opts = {})
  Capybara.register_driver(name) do |app|
    options = { args: args + ["window-size=1440,1080"] }
    options[:binary] = ENV.fetch("GOOGLE_CHROME_SHIM", nil)
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome("goog:chromeOptions" => options.compact)
    Capybara::Selenium::Driver.new(app, { browser: :chrome, desired_capabilities: capabilities }.merge(opts))
  end
end

register_driver(:chrome)
register_driver(:chrome_headless, %w[headless disable-gpu no-sandbox disable-dev-shm-usage])

Capybara.default_driver = Capybara.javascript_driver = ENV.fetch("CAPYBARA_DRIVER", "chrome_headless").to_sym

Capybara.app_host = "http://localhost:31337"
Capybara.server_host = "localhost"
Capybara.server_port = "31337"

RSpec.configure do |config|
  config.before(:example, :slow) do
    Capybara.default_max_wait_time = Capybara.default_max_wait_time * 2
  end

  config.after(:example, :slow) do
    Capybara.default_max_wait_time = Capybara.default_max_wait_time / 2
  end

  config.after(:example, type: :feature) do
    FileUtils.remove_dir(Rails.root.join("public", "packs-test"))
    # Capybara.execute_script "localStorage.clear()" rescue nil
  end
end
