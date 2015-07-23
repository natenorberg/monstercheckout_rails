require 'rails_helper'

RSpec.describe PermissionsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Permission. As you add validations to Permission, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: 'Permission group', description: 'Permission for testing' }
  }

  let(:invalid_attributes) {
    { name: '', description: '' }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PermissionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "redirects to admin dashboard" do
      get :index, {}, valid_session
      expect(response).to redirect_to admin_path
    end
  end

  describe "GET show" do
    it "assigns the requested permission as @permission" do
      permission = Permission.create! valid_attributes
      get :show, {:id => permission.to_param}, valid_session
      expect(assigns(:permission)).to eq(permission)
    end
  end

  describe "GET new" do
    it "assigns a new permission as @permission" do
      get :new, {}, valid_session
      expect(assigns(:permission)).to be_a_new(Permission)
    end
  end

  describe "GET edit" do
    it "assigns the requested permission as @permission" do
      permission = Permission.create! valid_attributes
      get :edit, {:id => permission.to_param}, valid_session
      expect(assigns(:permission)).to eq(permission)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Permission" do
        expect {
          post :create, {:permission => valid_attributes}, valid_session
        }.to change(Permission, :count).by(1)
      end

      it "assigns a newly created permission as @permission" do
        post :create, {:permission => valid_attributes}, valid_session
        expect(assigns(:permission)).to be_a(Permission)
        expect(assigns(:permission)).to be_persisted
      end

      it "redirects to the created permission" do
        post :create, {:permission => valid_attributes}, valid_session
        expect(response).to redirect_to(Permission.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved permission as @permission" do
        post :create, {:permission => invalid_attributes}, valid_session
        expect(assigns(:permission)).to be_a_new(Permission)
      end

      it "re-renders the 'new' template" do
        post :create, {:permission => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        { name: 'New Name', description: 'New Description' }
      }

      it "updates the requested permission" do
        permission = Permission.create! valid_attributes
        put :update, {:id => permission.to_param, :permission => new_attributes}, valid_session
        permission.reload
        expect(permission.name).to eq('New Name')
        expect(permission.description).to eq('New Description')
      end

      it "assigns the requested permission as @permission" do
        permission = Permission.create! valid_attributes
        put :update, {:id => permission.to_param, :permission => valid_attributes}, valid_session
        expect(assigns(:permission)).to eq(permission)
      end

      it "redirects to the permission" do
        permission = Permission.create! valid_attributes
        put :update, {:id => permission.to_param, :permission => valid_attributes}, valid_session
        expect(response).to redirect_to(permission)
      end
    end

    describe "with invalid params" do
      it "assigns the permission as @permission" do
        permission = Permission.create! valid_attributes
        put :update, {:id => permission.to_param, :permission => invalid_attributes}, valid_session
        expect(assigns(:permission)).to eq(permission)
      end

      it "re-renders the 'edit' template" do
        permission = Permission.create! valid_attributes
        put :update, {:id => permission.to_param, :permission => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested permission" do
      permission = Permission.create! valid_attributes
      expect {
        delete :destroy, {:id => permission.to_param}, valid_session
      }.to change(Permission, :count).by(-1)
    end

    it "redirects to the admin dashboard" do
      permission = Permission.create! valid_attributes
      delete :destroy, {:id => permission.to_param}, valid_session
      expect(response).to redirect_to(admin_path)
    end
  end

end
