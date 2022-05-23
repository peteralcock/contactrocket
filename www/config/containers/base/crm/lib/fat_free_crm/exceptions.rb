# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
module ContactRocketCRM
  class MissingSettings < StandardError; end
  class ObsoleteSettings < StandardError; end
end

class ActionController::Base
  rescue_from ContactRocketCRM::MissingSettings,  with: :render_contact_rocket_crm_exception
  rescue_from ContactRocketCRM::ObsoleteSettings, with: :render_contact_rocket_crm_exception

  private

  def render_contact_rocket_crm_exception(exception)
    logger.error exception.inspect
    render layout: false, template: "/layouts/500", format: :html, status: 500, locals: { exception: exception }
  end
end
