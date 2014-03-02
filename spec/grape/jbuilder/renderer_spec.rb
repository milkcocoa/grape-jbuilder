require 'spec_helper'

describe Grape::Jbuilder::Renderer do
  let(:engine) { double :render => '' }
  let(:scope)  { double }

  before :each do
    Tilt.stub :new => engine
  end

  describe '#render' do
    it "raises an error if the view path is nil" do
      renderer = Grape::Jbuilder::Renderer.new(nil, 'file')

      expect { renderer.render scope }.to raise_error
    end

    it "creates a new Tilt engine with the file and view path" do
      renderer = Grape::Jbuilder::Renderer.new('/tmp', 'file.jbuilder')

      expect(Tilt).to receive(:new).
        with('/tmp/file.jbuilder', nil, :view_path => '/tmp').
        and_return(engine)

      renderer.render scope
    end

    it "appends jbuilder extension to the file if required" do
      renderer = Grape::Jbuilder::Renderer.new('/tmp', 'file')

      expect(Tilt).to receive(:new).
        with('/tmp/file.jbuilder', nil, :view_path => '/tmp').
        and_return(engine)

      renderer.render scope
    end

    it "renders with the provided scope and locals" do
      renderer = Grape::Jbuilder::Renderer.new('/tmp', 'file')

      expect(engine).to receive(:render).with(scope, :foo => :bar).
        and_return('')

      renderer.render scope, :foo => :bar
    end
  end
end
