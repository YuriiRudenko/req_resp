account_id = Account.first_or_create.id

%w[John\ Doe Foo\ Bar].each do |name|
  user_id = User.find_or_create_by(name: name, workflow_state: :registered).id
  AccountUser.find_or_create_by(account_id: account_id, user_id: user_id)
end
