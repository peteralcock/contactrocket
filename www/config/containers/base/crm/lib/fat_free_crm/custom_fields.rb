# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------

#
# Register CustomFields when Field class is loaded
ActiveSupport.on_load(:contact_rocket_crm_field) do # self == Field
  register(as: 'date_pair', klass: 'CustomFieldDatePair', type: 'date')
  register(as: 'datetime_pair', klass: 'CustomFieldDatetimePair', type: 'timestamp')
end
