# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class Uninstall
  class Uninstall < Manager
    def execute(package)
      @logger.debug "Install.execute(#{package}) called."
      family = osfamily
      command = case family
                when 'Archlinux'
                  "sudo pacman -R '#{package}'"
                when 'RedHat'
                  pkgmgr = os_package_manager
                  "sudo #{pkgmgr} remove '#{package}'"
                when 'Debian'
                  "sudo apt remove '#{package}'"
                else
                  raise "Uninstall not supported for family: #{family}" # TODO: create custom Exception
                end
      run(command)
    end
  end
end
