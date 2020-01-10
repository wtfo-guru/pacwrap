# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class manage
  class Ffile < Manager
    def execute(fullpathname)
      @logger.debug "Ffile.execute(#{fullpathname}) called."
      run(command(fullpathname))
    end

    def command(param)
      family = osfamily
      case family
      when 'Archlinux'
        "pacman -Qo '#{param}'"
      when 'RedHat'
        "rpm -qf '#{param}'"
      when 'Debian'
        "dpkg -S '#{param}'"
      else
        raise "File not supported for family: #{family}" # TODO: create custom Exception
      end
    end
  end
end
