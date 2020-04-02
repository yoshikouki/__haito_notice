require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  describe "バリデーション" do
    context "全体" do
      it "Userは有効" do
        expect(user).to be_valid
      end

      it "不正なインスタンスは保存できない" do
        user.email = "    "
        expect(user.save).to be_falsey
      end
    end

    context "name" do
      it "nameは必須" do
        user.name = "    "
        expect(user).to be_invalid
      end

      it "nameは50文字以内" do
        user.name = "a" * 51
        expect(user).to be_invalid
      end
    end

    context "email" do
      # 正しいメールアドレスの定義
      let(:valid_addresses) do
        %w[
          user@example.com
          USER@foo.COM
          A_US-ER@foo.bar.org
          first.last@foo.jp
          alice+bob@baz.cn
        ]
      end

      # 不正なメールアドレスの定義
      let(:invalid_addresses) do
        %w[
          user@example,com
          user_at_foo.org
          user.name@example.foo@bar_baz.com
          foo@bar+baz.com
          foo@bar..com
        ]
      end

      it "emailは必須" do
        user.email = "    "
        expect(user).to be_invalid
      end

      it "正しいemailはパスする" do
        valid_addresses.each do |a|
          user.email = a
          expect(user).to be_valid
        end
      end

      it "不正なemailはパスしない" do
        invalid_addresses.each do |a|
          user.email = a
          expect(user).to be_invalid
        end
      end

      it "emailは常にユニーク" do
        duplicate_user = user.dup
        duplicate_user.email = user.email.upcase
        user.save
        expect(duplicate_user).to be_invalid
      end

      it "emailは255文字以内" do
        user.email = "a" * 246 + "@email.com"
        expect(user).to be_invalid
      end

      it "emailは小文字で保存" do
        mixed_case_email = "Foo@ExAMPle.CoM"
        user.email = mixed_case_email
        user.save
        expect(mixed_case_email.downcase == user.reload.email).to \
          be true
      end
    end

    context "password" do
      it "passwordは必須" do
        user = FactoryBot.build(:user, password: "")
        expect(user).to be_invalid
      end

      it "password_confirmationは必須" do
        user.password_confirmation = "    "
        expect(user).to be_invalid
      end

      it "passwordとpassword_confirmationは一致" do
        user.password_confirmation = "wrongPassword"
        expect(user).to be_invalid
      end

      it "passwordは空白を許さない" do
        user.password = user.password_confirmation = " " * 6
        expect(user).to be_invalid
      end

      it "passwordが短すぎてはいけない" do
        user.password = user.password_confirmation = "a" * 5
        expect(user).to be_invalid
      end
    end
  end

  describe "関連性" do
    context "ウォッチリスト" do
      it "ユーザー削除と同時にウォッチリストも削除される" do
      end
    end
  end
end
