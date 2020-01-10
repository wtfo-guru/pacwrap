# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class manage
  class Files < Manager
    def execute(package)
      @logger.debug "Files.execute(#{package}) called."
      # command = case osfamily
      #           when 'Archlinux'
      #             "pacman -Qo '#{fullpathname}'"
      #           when 'RedHat'
      #             "rpm -qf '#{fullpathname}'"
      #           when 'Debian'
      #             "dpkg -S '#{fullpathname}'"
      #           end
      # run(command)
    end
  end
end
