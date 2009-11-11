require 'vte_controller'

class ServerController < VteController
  def initialize(main)
    super(main)
    @role = 'Server'
  end

  def open(new_project)
    close if project

    project = new_project
    exec("cd #{project.path}")
    exec("ruby script/server -p #{project.port}")
    project.start_server!
  end

  def close
    flunk "not implemented"
  end
end
