require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'IdpController' do

  scenario 'Login via default signup page' do
    saml_request = make_saml_request("http://foo.example.com/saml/consume")
    visit "/saml/auth?SAMLRequest=#{CGI.escape(saml_request)}"
    fill_in 'Email', :with => "brad.copa@example.com"
    fill_in 'Password', :with => "okidoki"
    click_button 'Sign in'
    click_button 'Submit'   # simulating onload
    expect(current_url).to eq('http://foo.example.com/saml/consume')
    expect(page).to have_content("brad.copa@example.com")
  end

  scenario 'forgery is protected with exception' do
    saml_request = make_saml_request("http://foo.example.com/saml/consume")
    visit "/saml/auth?SAMLRequest=#{CGI.escape(saml_request)}"
    find("input[name='authenticity_token']", visible: false).set("invalid-authenticity-token")
    fill_in 'Email', :with => "brad.copa@example.com"
    fill_in 'Password', :with => "okidoki"
    click_button 'Sign in'
    byebug
    expect(page).to have_content("Can't verify CSRF token authenticity.")
  end

end
