# frozen_string_literal: true

# require 'logging'
require 'pacwrap/uninstall'

supported = %w{Archlinux Debian RedHat Gentoo}
unsupported = %w{}
param = 'ruby'

supported.each do |family|
  regex = case family
          when 'Archlinux'
            "sudo pacman -R '#{param}'"
          when 'RedHat'
            "sudo (dnf|yum) remove '#{param}'"
          when 'Debian'
            "sudo apt remove '#{param}'"
          when 'Gentoo'
            "sudo emerge --ask -C '#{param}'"
          end

  RSpec.describe Pacwrap::Uninstall do
    it "command is correct for #{family}" do
      obj = described_class.new('test' => family, 'debug' => false, 'verbose' => false)
      expect(obj.command(param)).to match(%r{#{regex}})
    end
  end
end

unsupported.each do |family|
  RSpec.describe Pacwrap::Uninstall do
    it "command creates RuntimeError for #{family}" do
      obj = described_class.new('test' => family, 'debug' => false, 'verbose' => false)
      expect { obj.command(param) }.to raise_error("Uninstall not supported for family: #{family}")
    end
  end
end

RSpec.describe Pacwrap::Uninstall do
  it 'object creation generates RuntimeError for Bogus' do
    expected = 'Invalid osfamily Bogus, not one of (Debian Gentoo RedHat Archlinux)'
    expect { described_class.new('test' => 'Bogus', 'debug' => false, 'verbose' => false) }.to raise_error(expected)
  end
end
