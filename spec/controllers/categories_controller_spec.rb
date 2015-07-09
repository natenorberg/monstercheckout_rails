require 'rails_helper'

RSpec.describe CategoriesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Category. As you add validations to Category, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { name: 'Test Category', description: 'Description' }
  }

  let(:invalid_attributes) {
    { name: '', description: 'Description' }
  }

  def invalid_session
    controller.stub(:signed_in?).and_return(false)
  end

  def valid_session
    controller.stub(:user_signed_in).and_return(true)

    mock_user = stub_model(User)
    mock_user.stub(:is_admin?).and_return(false)
    controller.stub(:current_user).and_return(mock_user)
  end

  def admin_session
    controller.stub(:user_signed_in).and_return(true)
    controller.stub(:user_is_admin).and_return(true)
  end

  describe "GET index" do
    it "assigns all categories as @categories" do
      category = Category.create! valid_attributes
      get :index, {}, admin_session
      expect(assigns(:categories)).to eq([category])
    end
  end

  describe "GET show" do
    before do
      @category = Category.create! valid_attributes
    end

    it "assigns the requested category as @category" do
      get :show, {:id => @category.to_param}, admin_session
      expect(assigns(:category)).to eq(@category)
    end

    it 'renders the equipment/index view' do
      get :show, {:id => @category.to_param}, admin_session
      expect(response).to render_template('equipment/index')
    end
  end

  describe "GET new" do
    it "assigns a new category as @category" do
      get :new, {}, admin_session
      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe "GET edit" do
    it "assigns the requested category as @category" do
      category = Category.create! valid_attributes
      get :edit, {:id => category.to_param}, admin_session
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, {:category => valid_attributes}, admin_session
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create, {:category => valid_attributes}, admin_session
        expect(assigns(:category)).to be_a(Category)
        expect(assigns(:category)).to be_persisted
      end

      it "redirects to the created category" do
        post :create, {:category => valid_attributes}, admin_session
        expect(response).to redirect_to(Category.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved category as @category" do
        post :create, {:category => invalid_attributes}, admin_session
        expect(assigns(:category)).to be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        post :create, {:category => invalid_attributes}, admin_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        { name: 'New Category', description: 'Brand new description' }
      }

      it "updates the requested category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => new_attributes}, admin_session
        category.reload
        expect(category.name).to eq('New Category')
        expect(category.description).to eq('Brand new description')
      end

      it "assigns the requested category as @category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => valid_attributes}, admin_session
        expect(assigns(:category)).to eq(category)
      end

      it "redirects to the category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => valid_attributes}, admin_session
        expect(response).to redirect_to(category)
      end
    end

    describe "with invalid params" do
      it "assigns the category as @category" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => invalid_attributes}, admin_session
        expect(assigns(:category)).to eq(category)
      end

      it "re-renders the 'edit' template" do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => invalid_attributes}, admin_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested category" do
      category = Category.create! valid_attributes
      expect {
        delete :destroy, {:id => category.to_param}, admin_session
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      category = Category.create! valid_attributes
      delete :destroy, {:id => category.to_param}, admin_session
      expect(response).to redirect_to(categories_url)
    end
  end

  describe 'when not logged in' do
    describe 'GET index' do
      it 'redirects to signin_url' do
        get :index, {}, invalid_session
        expect(response).to redirect_to(signin_url)
      end
    end

    describe 'GET show' do
      it 'redirects to signin_url' do
        category = Category.create! valid_attributes
        get :show, {:id => category.to_param}, invalid_session
        expect(response).to redirect_to(signin_url)
      end
    end

    describe 'GET new' do
      it 'redirects to signin_url' do
        get :new, {}, invalid_session
        expect(response).to redirect_to(signin_url)
      end
    end

    describe 'GET edit' do
      it 'redirects to signin_url' do
        category = Category.create! valid_attributes
        get :edit, {:id => category.to_param}, invalid_session
        expect(response).to redirect_to(signin_url)
      end
    end

    describe 'POST create' do
      it 'redirects to signin_url' do
        post :create, {:category => valid_attributes}, invalid_session
        expect(response).to redirect_to(signin_url)
      end
    end

    describe 'PUT update' do
      let(:new_attributes) {
        { name: 'New Category', description: 'Brand new description' }
      }

      it 'redirects to signin_url' do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => new_attributes}, invalid_session
        expect(response).to redirect_to(signin_url)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to signin_url' do
        category = Category.create! valid_attributes
        delete :destroy, {:id => category.to_param}, invalid_session
        expect(response).to redirect_to(signin_url)
      end
    end
  end

  describe 'when not an admin' do
    describe 'GET index' do
      it 'redirects to root_url' do
        get :index, {}, valid_session
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'GET show' do
      it 'redirects to root_url' do
        category = Category.create! valid_attributes
        get :show, {:id => category.to_param}, valid_session
        expect(response.status).to eq(200)
      end
    end

    describe 'GET new' do
      it 'redirects to root_url' do
        get :new, {}, valid_session
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'GET edit' do
      it 'redirects to root_url' do
        category = Category.create! valid_attributes
        get :edit, {:id => category.to_param}, valid_session
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'POST create' do
      it 'redirects to root_url' do
        post :create, {:category => valid_attributes}, valid_session
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'PUT update' do
      let(:new_attributes) {
        { name: 'New Category', description: 'Brand new description' }
      }

      it 'redirects to root_url' do
        category = Category.create! valid_attributes
        put :update, {:id => category.to_param, :category => new_attributes}, valid_session
        expect(response).to redirect_to(root_url)
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to root_url' do
        category = Category.create! valid_attributes
        delete :destroy, {:id => category.to_param}, valid_session
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
