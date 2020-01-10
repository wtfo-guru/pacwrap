# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class manage
  class File < Manager
    def execute(fullpathname)
      @logger.debug "File.execute(#{fullpathname}) called."
      family = osfamily
      command = case family
                when 'Archlinux'
                  "pacman -Qo '#{fullpathname}'"
                when 'RedHat'
                  "rpm -qf '#{fullpathname}'"
                when 'Debian'
                  "dpkg -S '#{fullpathname}'"
                else
                  raise "File not supported for family: #{family}" # TODO: create custom Exception
                end
      run(command)
    end
  end
end
