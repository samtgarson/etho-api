class TemplateController < AbstractController::Base
  include AbstractController::Logger
  include AbstractController::Rendering
  if defined?(AbstractController::Layouts)
    include AbstractController::Layouts
  else
    include ActionView::Layouts
  end
  include AbstractController::Helpers
  include AbstractController::Translation
  include AbstractController::AssetPaths
  include Rails.application.routes.url_helpers

  self.view_paths = 'app/templates'
  self.assets_dir = 'app/public'

  helper ApplicationHelper

  class << self
    def files
      @files ||= Dir[Rails.root.join('app', 'templates', '*', '**', '**')]
    end

    def render_templates
      controller = TemplateController.new
      files.reject! { |f| File.basename(f)[0] == '_' }
      files.each_with_object({}) do |file, result|
        next unless (m = file.match %r{#{prefix}\/(.+).(haml|slim)})
        template_name = m[1]
        puts template_name.inspect
        result[template_name] = controller.r(template_name)
      end
    end

    def file_names
      files
        .map do |file|
          next unless (m = file.match %r{#{prefix}\/(.+).(haml|slim)})
          m[1]
        end
    end

    private

    def prefix
      @prefix ||= Rails.root.join('app', 'templates').to_s
    end
  end

  def r(partial, options = {})
    I18n.with_locale options[:locale] || :en do
      render template: partial
    end
  end
end
