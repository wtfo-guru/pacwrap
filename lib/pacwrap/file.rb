# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class manage
  class File < Manager
    def execute(fullpathname)
      @logger.debug "File.execute(#{fullpathname}) called."
      command = case osfamily
                when 'Archlinux'
                  "pacman -Qo '#{fullpathname}'"
                when 'RedHat'
                  "rpm -qf '#{fullpathname}'"
                when 'Debian'
                  "dpkg -S '#{fullpathname}'"
                end
      run(command)
    end
  end
end
