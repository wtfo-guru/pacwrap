# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class manage
  class File < Manager
    def execute(package)
      @logger.debug "Install.execute(#{package}) called."
      command = case osfamily
                when 'Archlinux'
                  "sudo pacman -Ss '#{package}'"
                when 'RedHat'
                  pkgmgr = os_package_manager
                  "sudo #{pkgmgr} install '#{package}'"
                when 'Debian'
                  "sudo apt install '#{package}'"
                end
      run(command)
    end
  end
end
