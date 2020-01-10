# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class List
  class List < Manager
    def execute(package)
      @logger.debug "Find.execute(#{package}) called."
      return packages unless package.nil?

      family = osfamily
      command = case family
                when 'Archlinux'
                  "pacman -Ql '#{package}'"
                when 'RedHat'
                  pkgmgr = os_package_manager
                  "#{pkgmgr} -ql '#{package}'" # TODO: verbose?
                when 'Debian'
                  "dpkg -L '#{package}'" # TODO: --names-only
                else
                  raise "List package not supported for family: #{family}" # TODO: create custom Exception?
                end
      run(command)
    end

    def packages
      @logger.debug 'Find.packages()) called.'

      family = osfamily
      command = case family
                when 'Archlinux'
                  'pacman -Qe'
                when 'RedHat'
                  "rpm -qa --qf '%{name}-%{version}-%{release}.%{arch}.rpm\\n' | sort"
                when 'Debian'
                  'apt list --installed | sort'
                when 'Gentoo'
                  'qlist -Iv'
                else
                  raise "List packages not supported for family: #{family}" # TODO: create custom Exception?
                end
      run(command)
    end
  end
end
