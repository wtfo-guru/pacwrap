# frozen_string_literal: true

require 'pacwrap/manager'

package = 'Broccoli'

RSpec.describe Pacwrap::Manager do
  it 'broccoli installs' do
    expect(Pacwrap::Manager.install(package)).to eql(package)
  end
end
