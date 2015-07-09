Fabricator(:route) do
  id Fabricate.sequence(:id) { |i| "route-#{i}" }
  name Fabricate.sequence(:name) { |i| "name-#{i}" }
  path Fabricate.sequence(:path) { |i| "path-#{i}" }
end
