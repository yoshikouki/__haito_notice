require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { FactoryBot.create(:inact) }
    let(:mail) { UserMailer.account_activation(user) }

    before do
      user.activation_token = User.new_token
    end

    it { expect(mail.subject).to eq "配当ノーティスへのご登録をありがとうございます！" }
    it { expect(mail.to[0]).to eq user.email }
    it { expect(mail.from[0]).to eq "noreply@example.com" }
    it { expect(mail.body.encoded).to match user.name }
    it { expect(mail.body.encoded).to match user.activation_token }
    it { expect(mail.body.encoded).to match CGI.escape(user.email) }
  end
end
