# frozen_string_literal: true

# require 'logging'
require 'pacwrap/list'

supported = %w{Archlinux Debian RedHat Gentoo}
unsupported = %w{}
params = ['ruby', nil]

def list_package_cmd(family, param)
  case family
  when 'Archlinux'
    "pacman -Ql '#{param}'"
  when 'RedHat'
    "rpm -ql '#{param}'"
  when 'Debian'
    "dpkg -L '#{param}'"
  when 'Gentoo'
    "eqm -ql '#{param}'"
  end
end

def list_all_cmd(family)
  case family
  when 'Archlinux'
    'pacman -Qe'
  when 'RedHat'
    "rpm -qa --qf '%{name}-%{version}-%{release}.%{arch}.rpm\\n' | sort"
  when 'Debian'
    'apt list --installed | sort'
  when 'Gentoo'
    'qlist -IRv'
  end
end
supported.each do |family|
  params.each do |param|
    expec = param.nil? ? list_all_cmd(family) : list_package_cmd(family, param)

    RSpec.describe Pacwrap::List do
      p = param.nil? ? 'nil' : param
      it "command is correct for #{family} and #{p}" do
        obj = described_class.new('test' => family, 'debug' => false, 'verbose' => false)
        expect(obj.command(param)).to eql(expec)
      end
    end
  end
end

unsupported.each do |family|
  RSpec.describe Pacwrap::List do
    it "command creates RuntimeError for #{family}" do
      obj = described_class.new('test' => family, 'debug' => false, 'verbose' => false)
      expect { obj.command(param) }.to raise_error("List not supported for family: #{family}")
    end
  end
end

RSpec.describe Pacwrap::List do
  it 'object creation generates RuntimeError for Bogus' do
    expected = 'Invalid osfamily Bogus, not one of (Debian Gentoo RedHat Archlinux)'
    expect { described_class.new('test' => 'Bogus', 'debug' => false, 'verbose' => false) }.to raise_error(expected)
  end
end
