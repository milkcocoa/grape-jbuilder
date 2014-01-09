module Grape
  module Formatter
    class Jbuilder
      attr_reader :env, :endpoint, :object

      def self.call(object, env)
        new(object, env).call
      end

      def initialize(object, env)
        @object, @env = object, env
        @endpoint     = env['api.endpoint']
      end

      def call
        return Grape::Formatter::Json.call(object, env) unless template?

        Grape::Jbuilder::Renderer.new(
          env['api.tilt.root'], endpoint.options[:route_options][:jbuilder]
        ).render(endpoint)
      end

      private

      def template?
        !! endpoint.options.fetch(:route_options, {})[:jbuilder]
      end
    end
  end
end
