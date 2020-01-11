# frozen_string_literal: true

# require 'logging'
require 'pacwrap/info'

supported = %w{Archlinux Debian RedHat}
unsupported = %w{Gentoo}
param = 'ruby'

supported.each do |family|
  regex = case family
          when 'Archlinux'
            "pacman -Qi '#{param}'"
          when 'RedHat'
            "rpm -qi '#{param}'"
          when 'Debian'
            "apt-cache show '#{param}'"
          end

  RSpec.describe Pacwrap::Info do
    it "command is correct for #{family}" do
      obj = described_class.new('test' => family, 'debug' => false, 'verbose' => false)
      expect(obj.command(param)).to match(%r{#{regex}})
    end
  end
end

unsupported.each do |family|
  RSpec.describe Pacwrap::Info do
    it "command creates RuntimeError for #{family}" do
      obj = described_class.new('test' => family, 'debug' => false, 'verbose' => false)
      expect { obj.command(param) }.to raise_error("Info not supported for family: #{family}")
    end
  end
end

RSpec.describe Pacwrap::Info do
  it 'object creation generates RuntimeError for Bogus' do
    expected = 'Invalid osfamily Bogus, not one of (Debian Gentoo RedHat Archlinux)'
    expect { described_class.new('test' => 'Bogus', 'debug' => false, 'verbose' => false) }.to raise_error(expected)
  end
end
