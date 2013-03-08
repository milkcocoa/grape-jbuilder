module Grape
  module Formatter
    module Jbuilder
      class << self

        attr_reader :env
        attr_reader :endpoint

        def call(object, env)
          @env      = env
          @endpoint = env['api.endpoint']

          if jbuilderable?
            jbuilder do |template|
              engine = ::Tilt.new(view_path(template), nil, view_path: env['api.tilt.root'])
              engine.render(endpoint, {})
            end
          else
            Grape::Formatter::Json.call object, env
          end
        end

        private

        def view_path(template)
          if template.split('.')[-1] == 'jbuilder'
            File.join(env['api.tilt.root'], template)
          else
            File.join(env['api.tilt.root'], (template + '.jbuilder'))
          end
        end

        def jbuilderable?
          !! endpoint.options[:route_options][:jbuilder]
        end

        def jbuilder
          template = endpoint.options[:route_options][:jbuilder]
          raise 'missing jbuilder template' unless template
          set_view_root unless env['api.tilt.root']
          yield template
        end

        def set_view_root
          raise "Use Rack::Config to set 'api.tilt.root' in config.ru"
        end
      end
    end
  end
end
