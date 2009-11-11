class TabController < Rgtk::Controller::Base
  attr_accessor :project, :role, :tab_label, :main

  def initialize(main)
    @main = main
    super()
  end

  def role
    @role ||= controller_name.humanize
  end

  def tab_label
    @tab_label ||= Gtk::Label.new(full_title(role))
  end

  def title(new_title = nil)
    tab_label.text = full_title(new_title) unless new_title.nil?
    tab_label.text
  end
  alias_method :title=, :title

protected
  def full_title(title)
    if project?
      "#{project.name}: #{title}"
    else
      title
    end
  end

  def project?
    @project.present?
  end
end
