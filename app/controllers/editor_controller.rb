require 'vte_controller'

class EditorController < VteController
  def initialize(main)
    super(main)
    @role = 'Editor'
  end

  def open(new_project)
    unless project?
      self.project = new_project
      echo("#{project} is open")
      exec("cd #{project.path}")
      exec("vim config/environment.rb")
    end
  end

  def close
    puts "Editor project is closed"
    exec(":q")
    project = nil
  end
end
