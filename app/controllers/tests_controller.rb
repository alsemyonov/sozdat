require 'vte_controller'

class TestsController < VteController
  def initialize(main)
    super(main)
    @role = 'Tests'
  end

  def open(new_project)
    unless project?
      self.project = new_project
      echo "Starting tests for #{project}"
      exec("cd #{project.path}")
      exec("autotest")
    end
  end

end
