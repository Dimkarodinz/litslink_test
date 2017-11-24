RSpec.configure do |config|
  config.around(:each) do |example|
    DatabaseCleaner.strategy = self.class.metadata[:as_truncation] ? :truncation : :transaction
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end