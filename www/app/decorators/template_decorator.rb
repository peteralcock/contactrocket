class TemplateDecorator < Draper::Decorator
  include IconDecorator

  def owner
    object.user ? object.user.username : "Unknown"
  end

end
