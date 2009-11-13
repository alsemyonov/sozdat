class Project < ActiveRecord::Base
  before_validation :autoset_name
  validates_presence_of :name, :path

  attr_writer :port

  def port
    @port ||= 3000
  end

  def server_started?
    @server_started
  end

  def start_server!
    @server_started = true
  end

  def stop_server!
    @server_started = false
  end

  def to_s
    name
  end

protected
  def autoset_name
    self.name ||= File.basename(self.path)
  end
end
