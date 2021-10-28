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
                        visit sign_up_path
                        # Emailテキストフィールドにtest@example.comと入力
                        fill_in 'Email', with: 'test@example.com'
                        # Passwordテキストフィールドにpasswordと入力
                        fill_in 'Password', with: 'password'
                        # Password confirmationテキストフィールドにpasswordと入力
                        fill_in 'Password confirmation', with: 'password'
                        # SignUpと記述のあるsubmitをクリックする
                        click_button 'SignUp'
                        # login_pathへ遷移することを期待する
                        expect(current_path).to eq login_path
                        # 遷移されたページに'User was successfully created.'の文字列があることを期待する
                        expect(page).to have_content 'User was successfully created.'
                    end
                end
                context 'メールアドレス未記入' do
                    it 'ユーザーの新規作成が失敗' do
                        # ユーザー新規登録画面へ遷移
                        visit sign_up_path
                        # Emailテキストフィールドをnil状態にする
                        fill_in 'Email', with: nil
                        # Passwordテキストフィールドにpasswordと入力
                        fill_in 'Password', with: 'password'
                        # Password confirmationテキストフィールドにpasswordと入力
                        fill_in 'Password confirmation', with: 'password'
                        # SignUpと記述のあるsubmitをクリックする
                        click_button 'SignUp'
                        # users_pathへ遷移することを期待する
                        expect(current_path).to eq users_path
                        # 遷移されたページに'Email can't be blank'の文字列があることを期待する
                        expect(page).to have_content "Email can't be blank"
                    end
                end
                context '登録済メールアドレス' do
                    it 'ユーザーの新規作成が失敗する' do
                        # ユーザー新規登録画面へ遷移
                        visit sign_up_path
                        # Emailテキストフィールドにlet(:user)に定義したユーザーデータのemailを入力
                        fill_in 'Email', with: user.email
                        # Passwordテキストフィールドにpasswordと入力
                        fill_in 'Password', with: 'password'
                        # Password confirmationテキストフィールドにpasswordと入力
                        fill_in 'Password confirmation', with: 'password'
                        # SignUpと記述のあるsubmitをクリックする
                        click_button 'SignUp'
                        # users_pathへ遷移することを期待する
                        expect(current_path).to eq users_path
                        # 遷移されたページに'Email can't be blank'の文字列があることを期待する
                        expect(page).to have_content "Email has already been taken"
                    end
                end

            end
        end
        describe 'ログイン後' do
            before { login(user) }
                describe 'ユーザー編集'
                context 'フォームの入力値が正常' do
                    it 'ユーザーの編集が成功' do
                        visit edit_user_path(user)
                        fill_in 'Email', with: 'test@example.com'
                        fill_in 'Password', with: 'test'
                        fill_in 'Password confirmation', with: 'test'
                        click_button 'Update'
                        expect(current_path).to eq user_path(user)
                        expect(page).to have_content 'User was successfully updated.'
                    end
                end
                context 'メールアドレス未記入' do
                    it 'ユーザーの編集が失敗' do
                        visit edit_user_path(user)
                        fill_in 'Email', with: nil
                        fill_in 'Password', with: 'password'
                        fill_in 'Password confirmation', with: 'password'
                        click_button 'Update'
                        expect(current_path).to eq user_path(user)
                        expect(page).to have_content "Email can't be blank"
                    end
                end
        end

    end

end