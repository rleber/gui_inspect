# Determine the current environment (i.e. development, test, or production)

module Environment
  class << self
    def current_git_branch
      `git branch --show-current`.chomp
    end

    def current
      current_environment = ENV['RAILS_ENV'] || ENV['RACK_ENV']
      unless current_environment
        current_environment = current_git_branch == 'master' ? 'production' : 'development'
      end
      current_environment.downcase.to_sym
    end

    def production?
      current == :production
    end

    def non_production?
      !production?
    end

    def test?
      current == :test
    end

    def non_test?
      !test?
    end

    def development?
      non_test? && non_production?
    end

    def non_development?
      !development?
    end
  end
end 
