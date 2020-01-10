# frozen_string_literal: true

require 'logging'
require 'thor'

# sub commands
require 'pacwrap/list'

module Pacwrap
  # @class CLI
  class CLI < Thor

    desc 'file fullpathname', 'Determines package if any that include the file defined by fullpathname'
    def file(fullpathname)
      require 'pacwrap/file'
      Pacwrap::File.new.execute(fullpathname)
    end

    desc 'install package', 'Install a package'
    def install(package)
      require 'pacwrap/install'
      Pacwrap::File.new.execute(package)
    end

    desc 'list', 'Lists files in package or packages'
    subcommand 'list', List
  end
end
