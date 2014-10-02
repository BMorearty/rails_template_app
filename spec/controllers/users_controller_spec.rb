require 'spec_helper'

describe UsersController, type: :controller do
  render_views

  let(:unactivated_user) { FactoryGirl.create(:new_user) }
  let(:other_user) { FactoryGirl.create(:user) }

  context "logged out" do
    describe "GET edit" do
      it "requires logging in before editing any user's settings" do
        get :edit, id: other_user
        expect(response).to redirect_to(login_path)
      end
    end

    describe "GET new" do
      it "shows the Signup page" do
        get :new
        expect(response).to be_ok
        expect(assigns).to have_key(:user)
      end
    end

    describe "POST create" do
      it "creates a user and logs them in" do
        expect do
          post :create, user: { email: "goofy@disney.com", password: "hyuck", password_confirmation: "hyuck" }
        end.to change { User.count }.by(1)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include("Account created")

        # This is the format in which ResqueMailQueue enqueues emails
        expect(SorceryMailer).to have_queued('klass' => "SorceryMailer", 'method' => :activation_needed_email, 'args' => [User.last.id])
      end
    end

    describe "PUT update" do
      it "requires logging in" do
        put :update, id: other_user
        expect(response).to redirect_to(login_path)
      end
    end

    describe "DELETE destroy" do
      it "requires logging in" do
        delete :destroy, id: other_user.id
        expect(response).to redirect_to(login_path)
      end
    end

    describe "GET confirm_email" do
      it "returns 404 if the token is not found" do
        expect do
          get :confirm_email, id: unactivated_user.id, activation_token: "hello world"
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns 404 if the token is valid but does not match the user id" do
        expect do
          get :confirm_email, id: other_user.id, activation_token: unactivated_user.activation_token
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "activates the user and redirects to the login page" do
        expect(unactivated_user.activation_state).to eq("pending")
        get :confirm_email, id: unactivated_user.id, activation_token: unactivated_user.activation_token
        expect(unactivated_user.reload.activation_state).to eq("active")
        expect(response).to redirect_to(login_path(email: unactivated_user.email))
      end
    end
  end

  context "logged in" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      login_user user
    end

    describe "GET edit" do
      it "lets a user edit his own settings" do
        get :edit, id: user
        expect(response).to be_ok
        expect(assigns(:user)).to eq(user)
      end

      it "lets a user edit 'current' user settings" do
        get :edit, id: 'current'
        expect(response).to be_ok
        expect(assigns(:user)).to eq(user)
      end

      it "does not let a user edit another user's settings" do
        expect { get :edit, id: other_user }.to raise_error(ActiveRecord::RecordNotFound)
      end

      describe "when editing the password" do
        it "renders the edit password form and sets the edit_password flag in the form" do
          get :edit, id: user, edit_password: true
          expect(response).to be_ok
          expect(response).to render_template(:edit_password)
          expect(response.body).to have_css("input[name=edit_password][type=hidden]")
        end
      end
    end

    describe "PUT update" do
      it "does not allow updating another user" do
        expect do
          put :update, id: other_user.id, user: { name: "Goofy" }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "updates the user" do
        put :update, id: user.id, user: { name: "Goofy" }

        expect(response).to redirect_to(edit_user_path(user))
        expect(flash[:notice]).to include("Account settings were successfully changed.")
      end

      it "upon validation failure, renders the edit form" do
        put :update, id: user.id, user: { email: "invalid" }

        expect(response).to render_template(:edit)
        expect(response.body).to include("Email is invalid")
      end

      describe "changing the password" do
        it "updates the password" do
          put :update, id: user.id, edit_password: true, user: {
            old_password:          "secret",
            password:              "hyuck",
            password_confirmation: "hyuck"
          }

          expect(user.reload).to have_password("hyuck")
          expect(response).to redirect_to(edit_user_path(user))
          expect(flash[:notice]).to include("Password was successfully changed.")
        end

        it "upon validation failure, renders the edit_password form" do
          put :update, id: user.id, edit_password: true, user: {
            old_password:          "not the right password",
            password:              "hyuck",
            password_confirmation: "hyuck"
          }

          expect(response).to render_template(:edit_password)
          expect(response.body).to include("Old password is incorrect")
        end
      end
    end

    describe "DELETE destroy" do
      it "does not allow deleting another user" do
        expect { delete :destroy, id: other_user.id }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "deletes the user, logs out, and clears cookies" do
        cookies['username'] = user.name
        cookies['email'] = user.email
        expect(cookies['username']).not_to be_nil
        expect(cookies['email']).not_to be_nil

        delete :destroy, id: user.id

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include("Your account has been deleted")
        expect(cookies['username']).to be_nil
        expect(cookies['email']).to be_nil
      end
    end
  end

  context "logged in as an unactivated user" do
    let(:user) { FactoryGirl.create(:new_user) }

    before do
      login_user user
    end

    describe "GET confirm_email" do
      it "activates the user and redirects to the home page" do
        expect(user.activation_state).to eq("pending")
        get :confirm_email, id: user.id, activation_token: user.activation_token
        expect(user.reload.activation_state).to eq("active")
        expect(response).to redirect_to(root_path)
      end
    end

  end

end
