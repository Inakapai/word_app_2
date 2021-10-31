require 'rails_helper'


RSpec.describe User, type: :system do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    describe 'User CRUD' do
        describe 'ログイン前' do
            describe 'ユーザー新規登録' do
                context 'フォームの入力値が正常' do
                    it 'ユーザーの新規作成が成功' do
                        # ユーザー新規登録画面へ遷移
                        visit "/signup"
                        fill_in 'name', with: 'test'
                        # Emailテキストフィールドにtest@example.comと入力
                        fill_in 'email', with: 'test@example.com'
                        # Passwordテキストフィールドにpasswordと入力
                        fill_in 'password', with: 'password'
                        # Password confirmationテキストフィールドにpasswordと入力
                        fill_in 'c_password', with: 'password'
                        # SignUpと記述のあるsubmitをクリックする
                        click_button '作成'
                        # login_pathへ遷移することを期待する
                        expect(current_path).to eq "/posts/login"
                    end
                end
                context 'メールアドレス未記入' do
                    it 'ユーザーの新規作成が失敗' do
                        # ユーザー新規登録画面へ遷移
                        visit "/signup"
                        fill_in 'name', with: 'test'
                        # Emailテキストフィールドをnil状態にする
                        fill_in 'email', with: nil
                        # Passwordテキストフィールドにpasswordと入力
                        fill_in 'password', with: 'password'
                        # Password confirmationテキストフィールドにpasswordと入力
                        fill_in 'c_password', with: 'password'
                        # SignUpと記述のあるsubmitをクリックする
                        click_button '作成'
                        # users_pathへ遷移することを期待する
                        expect(current_path).to eq "/posts/create"
                        # 遷移されたページに'Email can't be blank'の文字列があることを期待する
                        expect(page).to have_content "メールアドレスを入力してください"
                    end
                end
                context '登録済メールアドレス' do
                    it 'ユーザーの新規作成が失敗する' do
                        # ユーザー新規登録画面へ遷移
                        visit "/signup"
                        fill_in 'name', with: 'test'
                        # Emailテキストフィールドにlet(:user)に定義したユーザーデータのemailを入力
                        fill_in 'email', with: user.email
                        # Passwordテキストフィールドにpasswordと入力
                        fill_in 'password', with: 'password'
                        # Password confirmationテキストフィールドにpasswordと入力
                        fill_in 'c_password', with: 'password'
                        sleep(7)
                        # SignUpと記述のあるsubmitをクリックする
                        click_button '作成'
                        # users_pathへ遷移することを期待する
                        expect(current_path).to eq "/posts/create"
                        # 遷移されたページに'Email can't be blank'の文字列があることを期待する
                        expect(page).to have_content "メールアドレスはすでに存在します"
                    end
                end

            end
        end
    end

end