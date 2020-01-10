# frozen_string_literal: true

require 'facter'

module Pacwrap
  # @class manage
  class Manager
    def initialize
      #    Logging.init :debug, :info, :warn, :error, :fatal
      @logger = Logging.logger['pacwrap']
      @logger.level = :debug
      @logger.add_appenders(Logging.appenders.stdout)
    end

    def run(command)
      system(command)
      $CHILD_STATUS
    end

    def os_id
      case @osrelease['ID']
      when %r{%gentoo$}i
        'Gentoo'
      when %r{%debian$}i
        'Debian'
      when %r{%fedora$}i
        'RedHat'
      end
    end

    def os_like
      case @osrelease['ID_LIKE']
      when %r{%arch$}i
        'Archlinux'
      when %r{%debian$}i
        'Debian'
      when %r{%redhat$}i
        'RedHat'
      end
    end

    def os_release_to_family
      return @osfamily if @osfamily

      @osrelease ||= load_properties('/etc/os-release')
      @osfamily ||= os_like if @osrelease.key?('ID_LIKE')
      @osfamily ||= os_id if @osrelease.key?('ID')
    rescue
      @osrelease = {}
      @osfamily
    end

    def osfamily
      return @osfamily if @osfamily

      @osfamily ||= os_release_to_family
      # Factor is slow so our last resort
      @osfamily ||= Facter.value(:osfamily)
    end

    def os_package_manager
      case osfamily
      when 'Archlinux'
        'pacman'
      when 'RedHat'
        dnf = %x(which dnf)
        if $CHILD_STATUS.zero?
          'dnf'
        else
          'yum'
        end
      when 'Debian'
        'apt'
      else
        'dunno'
      end
    end

    # Loads properties from a file with lines formatted as 'key=value' into a Hash.
    # Comments (lines starting with #) are skipped, as are lines starting with =.
    # Empty property values (lines ending with =) and property values containing = are included in the Hash.
    def load_properties(properties_filename)
      properties = {}
      File.open(properties_filename, 'r') do |properties_file|
        properties_file.read.each_line do |line|
          line.strip!
          next unless (line[0] != ?# and line[0] != ?=)

          i = line.index('=')
          if i
            properties[line[0..i - 1].strip] = line[i + 1..-1].strip
          else
            properties[line] = ''
          end
        end
      end
      properties
    end
  end
end