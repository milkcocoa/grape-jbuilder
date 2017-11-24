module Grape
  module Jbuilder
    class Renderer
      def initialize(view_path, template)
        @view_path, @template = view_path, template
      end

      def render(scope, locals = {})
        unless view_path
          raise "Use Rack::Config to set 'api.tilt.root' in config.ru"
        end

        assigns = scope.instance_variable_names.each_with_object({}) { |name, hash| hash[name[1..-1]] = scope.instance_variable_get(name)  }
        ApplicationController.render(file: 'api/v2/' + template, assigns: assigns)
      end

      private

      attr_reader :view_path, :template

      def file
        File.join view_path, template_with_extension
      end

      def template_with_extension
        template[/\.jbuilder$/] ? template : "#{template}.jbuilder"
      end
    end
  end
end
