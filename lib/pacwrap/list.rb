# frozen_string_literal: true

require 'pacwrap/manager'

module Pacwrap
  # @class List
  class List < Manager
    def execute(package)
      @logger.debug "Find.execute(#{package}) called."
      run(command(package) + suffix)
    end

    def command(param)
      param.nil? ? packages_command : command_package(param)
    end

    private

    def command_package(param)
      family = osfamily
      case family
      when 'Archlinux'
        "pacman -Ql '#{param}'"
      when 'RedHat'
        "rpm -ql '#{param}'" # TODO: verbose?
      when 'Debian'
        "dpkg -L '#{param}'" # TODO: --names-only
      when 'Gentoo'
        "eqm -ql '#{param}'" # requires gentoolkit
      else
        raise "List package not supported for family: #{family}" # TODO: create custom Exception?
      end
    end

    def packages_command
      family = osfamily
      case family
      when 'Archlinux'
        'pacman -Qe'
      when 'RedHat'
        "rpm -qa --qf '%{name}-%{version}-%{release}.%{arch}.rpm\\n' | sort"
      when 'Debian'
        'apt list --installed | sort'
      when 'Gentoo'
        'qlist -IRv'
      else
        raise "List packages not supported for family: #{family}" # TODO: create custom Exception?
      end
    end

    def suffix
      return '' unless @options.key?('output')

      output = @options['output']
      target = File.dirname(output)
      raise IOError, "Directory not found: #{target}" unless File.directory?(target)
      raise IOError, "Directory not writable: #{target}" unless File.writable?(target)

      quiet = @options.key?('quiet') ? @options['quiet'] : false
      if quiet
        " > '#{output}'"
      else
        " | tee '#{output}'"
      end
    end
  end
end
