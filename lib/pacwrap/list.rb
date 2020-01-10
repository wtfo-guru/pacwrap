# frozen_string_literal: true

require 'pacwrap/subs'

module Pacwrap
  # @class CLI
  class List < SubCommandBase
    desc 'files', 'Lists files in package'
    def files(package)
      require 'pacwrap/list/files'
      Pacwrap::Files.new.execute(package)
    end

    desc 'packages', 'Lists installed packages'
    def packages
      require 'pacwrap/list/packages'
      Pacwrap::Packages.new.execute
    end
  end
end
