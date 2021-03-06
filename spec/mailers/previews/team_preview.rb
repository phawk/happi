# Preview all emails at http://localhost:3000/rails/mailers/team
class TeamPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/team/not_found
  def not_found
    TeamMailer.not_found(Customer.first)
  end
end
