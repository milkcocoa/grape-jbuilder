require 'spec_helper'

describe Grape::Formatter::Jbuilder do
  let(:object)   { double }
  let(:env)      { {'api.endpoint' => endpoint, 'api.tilt.root' => '/tmp'} }
  let(:endpoint) { double :options => {} }
  let(:renderer) { double :render  => '' }

  before :each do
    Grape::Jbuilder::Renderer.stub :new => renderer

    endpoint.options[:route_options] = {:jbuilder => 'user'}
  end

  describe '.call' do
    it "passes the call to the Json render if no template is provided" do
      endpoint.options.clear

      expect(Grape::Formatter::Json).to receive(:call).with(object, env)

      Grape::Formatter::Jbuilder.call object, env
    end

    it "creates a renderer with the root and template" do
      expect(Grape::Jbuilder::Renderer).to receive(:new).with('/tmp', 'user').
        and_return(renderer)

      Grape::Formatter::Jbuilder.call object, env
    end

    it "accepts templates in the env hash" do
      env['api.tilt.template'] = 'foo'

      expect(Grape::Jbuilder::Renderer).to receive(:new).with('/tmp', 'foo').
        and_return(renderer)

      Grape::Formatter::Jbuilder.call object, env
    end

    it "passes the endpoint in as the render scope" do
      expect(renderer).to receive(:render).with(endpoint, {}).and_return('')

      Grape::Formatter::Jbuilder.call object, env
    end

    it "accepts custom locals for the render call" do
      env['api.tilt.locals'] = {:foo => :bar}

      expect(renderer).to receive(:render).with(endpoint, {:foo => :bar}).
        and_return('')

      Grape::Formatter::Jbuilder.call object, env
    end
  end
end
