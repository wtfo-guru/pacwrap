# frozen_string_literal: true

require 'logging'
require 'facter'
require 'fileutils'

module Pacwrap
  # @class manage
  class Manager
    def initialize(options)
      #    Logging.init :debug, :info, :warn, :error, :fatal
      @options = options
      # pp 'options: ', options
      if @options.key?('test')
        os_list = %w{Debian Gentoo RedHat Archlinux}
        # TODO: implement case insensitivity
        unless os_list.include?(@options['test'])
          valid = os_list.join(' ')
          raise "Invalid osfamily #{@options['test']}, not one of (#{valid})"
        end
        @osfamily = @options['test']
      end

      @logger = Logging.logger['pacwrap']
      @logger.level = if options['debug']
                        :debug
                      elsif options['verbose'] || @options.key?('test')
                        :info
                      else
                        :warn
                      end
      @logger.add_appenders(Logging.appenders.stdout)
      @refresh_flag = "/var/tmp/.pacwrap.refresh.flag.#{Process.uid}"
      @refresh_threshold = 7200 # two hours
    end

    def run(command)
      if @options.key?('test')
        @logger.info "[noex] \"#{command}\""
        10
      else
        system(command)
        $CHILD_STATUS
      end
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
      when %r{arch}i
        'Archlinux'
      when %r{debian}i
        'Debian'
      when %r{redhat}i
        'RedHat'
      else
        warn "unrecognized ID_LIKE: " + @osrelease['ID_LIKE']
      end
    end

    def os_release_to_family
      return @osfamily if @osfamily

      @osrelease ||= load_properties('/etc/os-release')
      # puts "osrelease keys: " + @osrelease.keys.inspect
      @osfamily ||= os_like if @osrelease.key?('ID_LIKE')
      @osfamily ||= os_id if @osrelease.key?('ID')
    rescue StandardError => _e
      @osrelease = {}
      @osfamily
    end

    def osfamily
      return @osfamily if @osfamily

      @osfamily ||= os_release_to_family
      # Factor is slow so our last resort
      @osfamily ||= Facter.value(:osfamily)
    end

    def refresh?
      return true unless File.exist?(@refresh_flag)

      age = Time.now.to_i - File.mtime(@refresh_flag).to_i
      age.negative? || age > @refresh_threshold
    end

    def refresh_package_lists
      return unless refresh?

      command = case osfamily
                when 'Archlinux'
                  'sudo pacman -Sy'
                when 'Gentoo'
                  'sudo emerge-websync'
                when 'Debian'
                  'sudo apt update'
                end
      run(command)
      FileUtils.touch(@refresh_flag)
    end

    def os_package_manager
      case osfamily
      when 'Archlinux'
        'pacman'
      when 'RedHat'
        dnf = Pacwrap.which 'dnf'
        if dnf.nil?
          'yum'
        else
          'dnf'
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
          next unless line[0] != '#' && line[0] != '='

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
