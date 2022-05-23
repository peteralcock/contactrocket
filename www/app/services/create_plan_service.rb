class CreatePlanService


  def call

    begin
    Plan.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('plans')
    rescue
      # ignore nil
    end


p1 = Plan.new({
                name: 'Startup',
                price: 20.00,
                interval: 'month',
                stripe_id: '1',
                description: "Just the basics...",
                features: ['Unlimited Contacts', '1000 URLs /month', 'Contact Search', '4X Engines', 'Bulk Targeting'].join("\n\n"),
                display_order: 1
            })

p2 = Plan.new({
                name: 'Advantage',
                price: 70.00,
                highlight: true,
                interval: 'month',
                stripe_id: '2',
                description: "The Popular Plan",
                features: ['Unlimited Contacts', '5000 URLs /month', 'Contact Search',  '8X Engines', 'Bulk Targeting', 'Email Validation'].join("\n\n"),
                display_order: 2
            })

p3 = Plan.new({
                name: 'Enterprise',
                price: 300.00,
                interval: 'month',
                description:"For the BIG LEAGUES!",
                stripe_id: '3',
                features: ['Unlimited Contacts', 'Unlimited Targets', 'Contact Search', '16X Engines', 'Bulk Targeting', 'Email Validation'].join("\n\n"),
                display_order: 3
            })

 p1.save!(:validate => false)
p2.save!(:validate => false)
p3.save!(:validate => false)

#coupon = Coupon.new(code: 'FREE30', free_trial_length: 30)
#coupon.save(:validate => false)

counter = Plan.count

puts "-- REGENERATED #{counter} PLANS -"
end


end

