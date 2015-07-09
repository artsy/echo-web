Fabricator(:message) do
  id Fabricate.sequence(:id) { |i| "message-#{i}" }
  name Fabricate.sequence(:name) { |i| "name-#{i}" }
  content Fabricate.sequence(:content) { |i| "content-#{i}" }
end
