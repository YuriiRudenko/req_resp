module Helpers
  SELECTABLE_COLUMNS = %i[uuid name sortable_name workflow_state].freeze

  # The order matters
  ERRORS = {
    incorrect: {
      code: 400,
      message: 'Incorrect id'
    },
    not_found: {
      code: 404,
      message: 'Account not found'
    }
  }.freeze

  def not_found_account?
    !Account.ids.map(&:to_i).include?(params[:account_id].to_i)
  end

  def validate_account
    ERRORS.each do |type, error_data|
      halt(error_data[:code], { error: error_data[:message] }.to_json) if send("#{type}_account?")
    end
  end

  def collect_users
    records = User.select(*SELECTABLE_COLUMNS)
                  .joins(:account_users)
                  .where(account_users: { account_id: params[:account_id] })

    records.map { |record| record.slice(SELECTABLE_COLUMNS) }.to_json
  end

  private

  def incorrect_account?
    params[:account_id].to_s != params[:account_id].to_i.to_s
  end
end
