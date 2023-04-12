module Whoop
  class InstallGenerator < Rails::Generators::Base
    desc "This generator creates an initializer file for the Whoop gem at config/initializers/whoop.rb, with default recommended settings."

    class_option :logger, type: :string, default: 'log/debug.log'
    class_option :level, type: :string, default: 'debug'

    VALID_LEVELS = %w[debug info warn error]

    def install
      @logger = options['logger']
      @level = options['level']

      unless VALID_LEVELS.include?(@level)
        log("Level must be one of #{VALID_LEVELS.join(", ")}\nAborting...\n")
        exit 1
      end

      file_contents = <<~TEXT
      Whoop.setup do |config|
        config.logger = ActiveSupport::Logger.new("#{@logger}")
        # config.logger = ActiveSupport::Logger.new("log/debug.log")
        # config.logger = ActiveSupport::Logger.new("log/\#{Rails.env}.log")
        # config.logger = ActiveSupport::Logger.new($stdout)
        # config.logger = nil # uses `puts`

        config.level = :#{@level}
        # config.level = :debug
        # config.level = :info
        # config.level = :warn
        # config.level = :error
      end
      TEXT

      create_file "config/initializers/whoop.rb", file_contents
    end
  end
end
