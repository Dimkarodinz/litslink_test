Rspec.configure do |config|
  DatabaseCleaner.strategy = :transaction

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end