module LoginModule
    def login(user)
      visit "/posts/login"
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'Login'
    end
  end