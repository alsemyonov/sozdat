require 'tab_controller'

class BrowserController < TabController
  def initialize(main)
    super
    @main = main
    @loading = false
    @current_uri = nil
  end

  def open(new_project)
    unless project?
      self.project = new_project
      open_url("http://127.0.0.1:#{project.port}/")
    end
  end

  def open_url(url)
    address(url)
    webview.open(url)
  end

protected
  signals_for(:browser) do
    # address entry
    activate(:address) { webview.open(address_entry.text) }
    # buttons
    activate(:go_forward) { webview.go_forward }
    activate(:go_back) { webview.go_back }
    activate(:stop_or_reload) do
      if @loading
        webview.stop_loading
      else
        webview.reload
      end
    end
    changed(:title) do |widget, frame, title|
      address(frame.uri)
    end
    changed(:load_progress) do |widget, progress|
      progress("%s%s loaded" % [progress, "%"])
    end
    on(:load_started) do |webview, frame|
      title("%s loading…" % [webview.uri])
      loading(true)
    end
    on(:load_finished) do |webview, frame|
      title(webview.title)
      loading(false)
    end
    on(:hovering_over_link) do |webview, title, url|
      status(webview && url ? url : '')
    end
  end

  def address(url)
    address_entry.text = url
    @current_uri = url
  end

  def loading(loading)
    @loading = loading

    if @loading
      browser_show_stop_icon
    else
      browser_show_reload_icon
    end

    update_navigation_buttons
  end

  def progress(progress)
    status(progress)
  end

  def status(text, context = nil)
    main.browser_statusbar.text = text
  end

  def browser_show_stop_icon
    stop_or_reload_button.stock_id = Gtk::Stock::CANCEL
    stop_or_reload_button.set_tooltip_text('Stop')
  end

  def browser_show_reload_icon
    stop_or_reload_button.stock_id = Gtk::Stock::REFRESH
    stop_or_reload_button.set_tooltip_text('Reload')
  end

  def update_navigation_buttons
    go_back.sensitive = webview.can_go_back?
    go_forward.sensitive = webview.can_go_forward?
  end

end
