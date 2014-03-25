
def demoted_tenancy_check(generated_values)
  generated_values["demoted_tenancy_demotion_order_date_day"].should == claim_post_data['claim']['demoted_tenancy']['demotion_order_date(3i)'].rjust(2, '0')
  generated_values["demoted_tenancy_demotion_order_date_month"].should == claim_post_data['claim']['demoted_tenancy']['demotion_order_date(2i)'].rjust(2, '0')
  generated_values["demoted_tenancy_demotion_order_date_year"].should == claim_post_data['claim']['demoted_tenancy']['demotion_order_date(1i)']
  generated_values['demoted_tenancy_demotion_order_court'].should == claim_post_data['claim']['demoted_tenancy']['demotion_order_court'].sub(' County Court','')
end
