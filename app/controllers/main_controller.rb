class MainController < Rgtk::Controller
  def on_quit_application
    close_all
    App.destroy
  end

  def preferences
    #TODO: show preferences
  end

  def about
    #TODO: show about box
  end
protected
  def close_all
    #TODO: close all open projects
  end
end
