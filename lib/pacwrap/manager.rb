# frozen_string_literal: true

require 'facter'

module Pacwrap
  # @class manage
  class Manager
    def initialize(options)
      #    Logging.init :debug, :info, :warn, :error, :fatal
      @options = options

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
    rescue StandardError => e
      @osrelease = {}
      @osfamily
    end

    def osfamily
      return @osfamily if @osfamily

      @osfamily ||= os_release_to_family
      # Factor is slow so our last resort
      @osfamily ||= Facter.value(:osfamily)
    end

    def refresh_package_lists
      @logger.debug 'method refresh_package_lists no implemented yet!'
      # typeset FLAG=/var/tmp/packages.refreshed.by.${IAM}
      # typeset LAST NOW ELAPSED
      # if [ -e "$FLAG" ]
      # then
      #   LAST=$(date -r "$FLAG" '+%S')
      #   NOW=$(date '+%S')
      #   ELAPSED=$((NOW-LAST))
      # else
      #   ELAPSED=$((86400*14))
      # fi
      # if [ $ELAPSED -gt 86400 ]
      # then
      #   touch "$FLAG"
      #   # refresh the package list
      #   case "$ID_LIKE" in
      #     arch )
      #       case "$ID" in
      #         manjaro )
      #           LAST=$((86400*14))
      #           if [ $ELAPSED -ge $MAX ]
      #           then
      #             sudo pacman-mirrors -c United_States
      #           fi
      #         ;;
      #         * )
      #         ;;
      #       esac
      #     ;;
      #     debian )
      #       sudo apt-update
      #     ;;
      #     gentoo )
      #       sudo emerge-websync
      #     ;;
      #     * )
      #     ;;
      #   esac
      # fi
    end

    # Cross-platform way of finding an executable in the $PATH.
    #
    #   which('ruby') #=> /usr/bin/ruby
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each { |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        }
      end
      return nil
    end

    def os_package_manager
      case osfamily
      when 'Archlinux'
        'pacman'
      when 'RedHat'
        dnf = which 'dnf'
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
