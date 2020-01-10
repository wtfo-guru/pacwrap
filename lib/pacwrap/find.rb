# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class Find
  class Find < Manager
    def execute(package)
      @logger.debug "Find.execute(#{package}) called."

      skip_refresh = true # TODO: implement skip/refresh

      refresh_package_lists unless skip_refresh

      run(command(package))
    end

    def command(param)
      family = osfamily
      case family
      when 'Archlinux'
        "sudo pacman -Ssy '#{param}'"
      when 'RedHat'
        pkgmgr = os_package_manager
        "sudo #{pkgmgr} search '#{param}'" # TODO: verbose?
      when 'Debian'
        "sudo apt search '#{param}'" # TODO: --names-only
      else
        raise "Find not supported for family: #{family}" # TODO: create custom Exception?
      end
    end
  end
end
