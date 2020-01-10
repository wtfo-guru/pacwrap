# frozen_string_literal: true

require 'logging'
require 'thor'

# sub commands
# require 'pacwrap/list'

module Pacwrap
  # @class CLI
  class CLI < Thor
    class_option :debug, :type => :boolean, :aliases => '-d', :default => false
    class_option :verbose, :type => :boolean, :aliases => '-v', :default => false
    class_option :test, :type => :string, :aliases => '-t'

    desc 'file FILE', 'Displays package if any that include the FILE'
    def file(fullpathname)
      require 'pacwrap/file'
      Pacwrap::File.new(options).execute(fullpathname)
    end

    desc 'install PACKAGE', 'Installs PACKAGE'
    def install(package)
      require 'pacwrap/install'
      Pacwrap::Install.new(options).execute(package)
    end

    desc 'uninstall PACKAGE', 'Unistalls PACKAGE'
    def uninstall(uninstall)
      require 'pacwrap/install'
      Pacwrap::Uninstall.new(options).execute(package)
    end

    desc 'list [PACKAGE]', 'Lists files in PACKAGE or installed packages when no PACKAGE specified'
    # subcommand 'list', List
    def list(package = nil)
      require 'pacwrap/list'
      Pacwrap::List.new(options).execute(package)
    end

    desc 'find PACKAGE', 'Searches repositories for PACKAGE'
    def find(package)
      require 'pacwrap/find'
      Pacwrap::Find.new(options).execute(package)
    end
  end
end
