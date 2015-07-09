Fabricator(:account) do
  id Fabricate.sequence(:id) { |i| "account-#{i}" }
  name Fabricate.sequence(:name) { |i| "name-#{i}" }
end
