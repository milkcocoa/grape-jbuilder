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

        Grape::Jbuilder::Renderer.new(env['api.tilt.root'], template).
          render(endpoint, locals)
      end

      private

      def locals
        env['api.tilt.locals'] || {}
      end

      def template
        env['api.tilt.template'] ||
        endpoint.options.fetch(:route_options, {})[:jbuilder]
      end

      def template?
        !!template
      end
    end
  end
end
