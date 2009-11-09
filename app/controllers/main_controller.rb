class MainController < Rgtk::Controller
  on :quit_application do
    close_all
    App.destroy
  end

  activate :create_project
  activate :open_project
  activate :save_project
  activate :save_project_as

  activate :browser_go_forward
  activate :browser_go_back

  activate :preferences
  activate :about

protected
  def close_all
    #TODO: close all open projects
  end
end
