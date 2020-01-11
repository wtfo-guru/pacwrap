# frozen_string_literal: true

require 'pacwrap/manager'

RSpec.describe Pacwrap::Manager do
  let(:manager) do
    described_class.new(
      'test' => 'Archlinux',
      'debug' => false,
      'verbose' => false
    )
  end

  it 'runs command' do
    expect(manager.run('wtfo rover')).to be(10)
  end
end
