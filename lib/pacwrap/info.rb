# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class Info
  class Info < Manager
    def execute(package)
      @logger.debug "Find.execute(#{package}) called."

      run(command(package))
    end

    def command(param)
      family = osfamily
      case family
      when 'Archlinux'
        "pacman -Qi '#{param}'"
      when 'RedHat'
        "rpm -qi '#{param}'"
      when 'Debian'
        "apt-cache show '#{param}'"
      else
        raise "Info not supported for family: #{family}" # TODO: create custom Exception?
      end
    end
  end
end
