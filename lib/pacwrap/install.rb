# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class Install
  class Install < Manager
    def execute(package)
      @logger.debug "Install.execute(#{package}) called."
      family = osfamily
      command = case family
                when 'Archlinux'
                  "sudo pacman -Ss '#{package}'"
                when 'RedHat'
                  pkgmgr = os_package_manager
                  "sudo #{pkgmgr} install '#{package}'"
                when 'Debian'
                  "sudo apt install '#{package}'"
                else
                  raise "Install not supported for family: #{family}" # TODO: create custom Exception
                end
      run(command)
    end
  end
end
