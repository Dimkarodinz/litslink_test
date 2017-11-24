RSpec.configure do |config|
  # config.around(:each) do |example|
  #   DatabaseCleaner.start
  #   example.run
  #   DatabaseCleaner.clean
  # end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:all) do
    # Clean before each example group if clean_as_group is set
    if self.class.metadata[:clean_as_group]
      DatabaseCleaner.clean
    end
  end

  config.after(:all) do
    # Clean after each example group if clean_as_group is set
    if self.class.metadata[:clean_as_group]
      DatabaseCleaner.clean
    end
  end

  config.before(:each) do
    # Clean before each example unless clean_as_group is set
    unless self.class.metadata[:clean_as_group]
      DatabaseCleaner.start
    end
  end

  config.after(:each) do
    # Clean before each example unless clean_as_group is set
    unless self.class.metadata[:clean_as_group]
      DatabaseCleaner.clean
    end
  end
end