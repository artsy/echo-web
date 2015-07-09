Fabricator(:feature) do
  id Fabricate.sequence(:id) { |i| "feature-#{i}" }
  name Fabricate.sequence(:name) { |i| "name-#{i}" }
  value Fabricate.sequence(:value) { |i| "value-#{i}" }
end
