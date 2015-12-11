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

    def non_partials
      files.delete_if { |f| File.basename(f)[0] == '_' }
    end

    def file_names
      non_partials
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
end
