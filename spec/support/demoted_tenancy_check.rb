
def demoted_tenancy_check(generated_values)
  expect(generated_values["demoted_tenancy_demotion_order_date_day"]).to eq(claim_post_data['claim']['demoted_tenancy']['demotion_order_date(3i)'].rjust(2, '0'))
  expect(generated_values["demoted_tenancy_demotion_order_date_month"]).to eq(claim_post_data['claim']['demoted_tenancy']['demotion_order_date(2i)'].rjust(2, '0'))
  expect(generated_values["demoted_tenancy_demotion_order_date_year"]).to eq(claim_post_data['claim']['demoted_tenancy']['demotion_order_date(1i)'])
  expect(generated_values['demoted_tenancy_demotion_order_court']).to eq(claim_post_data['claim']['demoted_tenancy']['demotion_order_court'].sub(' County Court',''))
end
