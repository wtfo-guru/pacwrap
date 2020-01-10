# frozen_string_literal: true

# require 'logging'
require 'pacwrap/ffile'

supported = %w{Archlinux Debian RedHat}
unsupported = %w{Gentoo}
param = '/usr/bin/ruby'

supported.each do |family|
  expected = case family
             when 'Archlinux'
               "pacman -Qo '#{param}'"
             when 'Debian'
               "dpkg -S '#{param}'"
             when 'RedHat'
               "rpm -qf '#{param}'"
             else
               'dunno'
             end

  RSpec.describe Pacwrap::Ffile do
    it "command is correct for #{family}" do
      obj = described_class.new('test' => family, 'debug' => false, 'verbose' => false)
      expect(obj.command(param)).to eql(expected)
    end
  end
end

unsupported.each do |family|
  RSpec.describe Pacwrap::Ffile do
    it "command creates RuntimeError for #{family}" do
      obj = described_class.new('test' => family, 'debug' => false, 'verbose' => false)
      expect { obj.command(param) }.to raise_error("File not supported for family: #{family}")
    end
  end
end

RSpec.describe Pacwrap::Ffile do
  it 'object creation generates RuntimeError for Bogus' do
    expected = 'Invalid osfamily Bogus, not one of (Debian Gentoo RedHat Archlinux)'
    expect { described_class.new('test' => 'Bogus', 'debug' => false, 'verbose' => false) }.to raise_error(expected)
  end
end
