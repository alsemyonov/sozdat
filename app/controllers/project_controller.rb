class ProjectController < Rgtk::Controller::Base
  attr_accessor :project

  def initialize(main)
    super()
    @main = main
  end

  def show(project, &block)
    self.project = project
    load_properties
    container.run(&block)
  end

  def hide
  end

protected
  def project
    unless @project
      @project = Project.new
    end
    @project
  end

  def load_properties
    if project.present?
      name_entry.text = project.name.to_s
      path_file_chooser_button.current_folder = project.path.to_s
    else
      self.project = Project.new
    end
  end

  def save_properties
    self.project.update_attributes(:name => name_entry.text,
                                   :path => path_file_chooser_button.current_folder)
  end

  signals_for(:project) do
    on :container_close do
      save_properties
      if project.valid?
        hide
      else
        flunk "show error"
      end
    end
    on :path_file_chooser_button_file_set
    activate :name_entry
  end
end
