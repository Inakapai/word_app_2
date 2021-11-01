module LoginModule
    def login(user)
      visit "/posts/login"
      fill_in 'email', with: user.email
      fill_in 'password', with: 'password'
      click_button 'login'
    end
  end