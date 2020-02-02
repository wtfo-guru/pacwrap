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
      require 'pacwrap/ffile'
      Pacwrap::Ffile.new(options).execute(fullpathname)
    end

    desc 'info PACKAGE', 'Display information about PACKAGE'
    def info(package)
      require 'pacwrap/info'
      Pacwrap::Info.new(options).execute(package)
    end

    desc 'install PACKAGE', 'Installs PACKAGE'
    def install(package)
      require 'pacwrap/install'
      Pacwrap::Install.new(options).execute(package)
    end

    desc 'uninstall PACKAGE', 'Unistalls PACKAGE'
    def uninstall(package)
      require 'pacwrap/uninstall'
      Pacwrap::Uninstall.new(options).execute(package)
    end

    desc 'list [PACKAGE]', 'Lists files in PACKAGE or installed packages when no PACKAGE specified.'
    method_option :output, :aliases => ['-o', '--out'], :desc => 'Save output to specify file.'
    method_option :quiet, :type => :boolean, :aliases => '-q', :desc => 'Suppress output to screen if -o.'
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

    map search: :find
  end
end
