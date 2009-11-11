require 'tab_controller'

class VteController < TabController
  def initialize(main)
    self.view_name = 'vte'
    self.controller_name = 'vte'
    super(main)
    terminal.fork_command
  end

  def exec(command = '')
    terminal.feed_child("#{command}\n")
  end

  def echo(message = '', br = true)
    terminal.feed(message)
    terminal.feed("\n") if br
  end

  def reset
    terminal.reset
  end
end
