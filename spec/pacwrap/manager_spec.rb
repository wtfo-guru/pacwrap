# frozen_string_literal: true

require 'logging'
require 'pacwrap/manager'

package = 'ruby'

RSpec.describe Pacwrap::Manager do
  let(:manager) {
    described_class.new(
      'test' => 'Archlinux',
      'debug' => false,
      'verbose' => false
    )
  }

  it 'runs command' do
    expect(manager.run 'wtfo rover').to eql(10)
  end
end
