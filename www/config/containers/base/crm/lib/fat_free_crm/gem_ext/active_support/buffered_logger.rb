# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
class ActiveSupport::BufferedLogger
  BRIGHT = "\033[1;37;40m"
  NORMAL = "\033[0m"

  def p(*args)
    info "#{BRIGHT}\n\n" << args.join(" ") << "#{NORMAL}\n\n\n"
  end

  def i(*args)
    info "#{BRIGHT}\n\n" << args.map(&:inspect).join(" ") << "#{NORMAL}\n\n\n"
  end
end
