# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :jasmine, server: :webrick, server_mount: '/specs', server_env: :development do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$}) { 'spec/javascripts' }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{spec/javascripts/fixtures/.+$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.#{ m[2] }" }
end

guard :rspec, cmd: 'bundle exec rspec', all_on_start: false do
  watch(%r{^spec/.+_spec\.rb$})

  watch(%r{^spec/models/(.+)_spec\.rb$}) { |m| "spec/models/#{m[1]}_spec.rb" }

  watch(%r{^spec/helpers/(.+)_spec\.rb$}) { |m| "spec/helpers/#{m[1]}_spec.rb" }

  # watch(%r{^spec/models/tenancy(.+)_spec\.rb$}) { |m| "spec/models/tenancy#{m[1]}_spec.rb" }

  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }

  watch(%r{^app/models/tenancy\.rb$})                 { |m| ["spec/models/tenancy_spec.rb", "spec/models/tenancy_assured_one_spec.rb", "spec/models/tenancy_assured_multiple_spec.rb"] }
  watch(%r{^spec/support/tenancy_helper\.rb$})        { |m| ["spec/models/tenancy_spec.rb", "spec/models/tenancy_assured_one_spec.rb", "spec/models/tenancy_assured_multiple_spec.rb"] }

  watch(%r{^app/models/claimant.*\.rb$})              { |m| ['spec/models/claimant_spec.rb', 'spec/models/claimant_collection_spec.rb'] }

  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  # watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }

  # Turnip features and steps
  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }

  watch(%r{^app/views/claim/new\.html\.haml$}) { |m| "spec/features/submit_claim_spec.rb" }

end
