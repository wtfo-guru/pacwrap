# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class Uninstall
  class Uninstall < Manager
    def execute(package)
      @logger.debug "Install.execute(#{package}) called."
      run(command(package))
    end

    def command(param)
      family = osfamily
      case family
      when 'Archlinux'
        "sudo pacman -R '#{param}'"
      when 'RedHat'
        pkgmgr = os_package_manager
        "sudo #{pkgmgr} remove '#{param}'"
      when 'Debian'
        "sudo apt remove '#{param}'"
      when 'Gentoo'
        "sudo emerge --ask -C '#{param}'"
      else
        raise "Uninstall not supported for family: #{family}" # TODO: create custom Exception
      end
    end
  end
end
