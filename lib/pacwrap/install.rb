# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class Install
  class Install < Manager
    def execute(package)
      @logger.debug "Install.execute(#{package}) called."

      run(command(package))
    end

    def command(param)
      family = osfamily
      case family
      when 'Archlinux'
        "sudo pacman -Ss '#{param}'"
      when 'RedHat'
        pkgmgr = os_package_manager
        "sudo #{pkgmgr} install '#{param}'"
      when 'Debian'
        "sudo apt install '#{param}'"
      when 'Gentoo'
        "sudo emerge --ask '#{param}'"
      else
        raise "Install not supported for family: #{family}" # TODO: create custom Exception
      end
    end
  end
end
