class MainController < Rgtk::Controller::Base
  module Perspective
    BROWSER = 4
    EDITOR = 1
    TESTS = 3
    SERVER = 2
  end

  def initialize
    super
    @tabs = {}
    load_projects_list
  end

  def load_projects_list
    projects_liststore = Gtk::ListStore.new(String, Project)
    Project.find_each do |project|
      iter = projects_liststore.append
      iter[0] = project.name
      iter[1] = project
    end
    project_selector_combobox.model = projects_liststore
    renderer = Gtk::CellRendererText.new
    project_selector_combobox.pack_start(renderer, true)
    project_selector_combobox.set_attributes(renderer, :text => 0)
  end

  def open_project(project)
    @project = project
    editor.open(@project)
  end

  def close_project
    if @project
      if @project.new_record?
        #TODO: show_project and add data
      end
      @project.save!
    end
  end

protected
  on :application_quit do
    close_project
    App.destroy
  end
  on :preferences
  on :about do
    @about ||= AboutController.new
    @about.show
  end

  signals_for(:project) do
    activate :create
    activate :open do
      if project_directory = open_project_dialog
        project = Project.find_or_create_by_path(project_directory)
        open_project(project)
      end
    end
    activate :save
    activate :save_as
    activate :properties do
      project_dialog.show(@project) do |*args|
        p args
      end
    end
    changed :selector_combobox do
      open_project(project_selector_combobox.active_iter[1])
    end
  end

  changed :action do |radio, group|
    if radio == group
      if @project
        self.current_perspective = group.current_value
      else
        puts "No project is open"
      end
    end
  end

  def current_perspective=(perspective)
    case perspective
    when Perspective::BROWSER
      server.open(@project) unless @project.server_started?
      browser.open(@project)
    when Perspective::EDITOR
      editor.open(@project)
    when Perspective::TESTS
      tests.open(@project)
    when Perspective::SERVER
      server.open(@project)
    else
      p perspective
    end
  end

  def tab(kind, active = true)
    unless @tabs[kind]
      controller = "#{kind}_controller".classify.constantize.new(self)
      project_notebook.append_page(controller.container, controller.tab_label)
      @tabs[kind] = {
        :controller => controller,
        :page_num => project_notebook.page_num(controller.container)
      }
    end
    if active
      self[:editor].current_value = Perspective.const_get(kind.upcase)
      project_notebook.page = @tabs[kind][:page_num]
    end
    @tabs[kind][:controller]
  end

  %w(browser editor server tests).each do |method|
    define_method(method) { |*args| tab(method, *args) }
  end

  def open_project_dialog
    project_directory = nil
    dialog = Gtk::FileChooserDialog.new(
                          'Open Project',
                          container,
                          Gtk::FileChooser::ACTION_OPEN,
                          'gnome-vfs',
                          [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT],
                          [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL]
    )
    file_filter = Gtk::FileFilter.new
    file_filter.name = 'Projects'
    file_filter.add_pattern('Rakefile')
    dialog.add_filter(file_filter)
    dialog.add_shortcut_folder(App.config.projects_directory)
    dialog.run do |response|
      if response == Gtk::Dialog::RESPONSE_ACCEPT
        project_directory = File.dirname(dialog.filename)
      end
    end
    dialog.destroy
    project_directory
  end

  def project_dialog
    unless @project_dialog
      @project_dialog = ProjectController.new(self)
    end
    @project_dialog
  end
end
