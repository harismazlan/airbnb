class ListingsController < ApplicationController
	before_action :set_listing, except: [:index, :new, :create]
	before_action :authorize_user, only: [:edit, :update, :destroy]

	def index
		@listings = Listing.all
	end

	def new
		@listing = Listing.new
	end

	def create
		@listing = current_user.listings.new(piglet_params)
		if @listing.save
			redirect_to listing_path(@listing), notice: "You have successfully listed your property!"
		else
			render :new, error: "Unfortunately an error has occured, please try creating your listing again!"
		end
	end

	def show
	end

	def edit
	end

	def update
		if @listing.update(listing_params)
			redirect_to listing_path(@listing), notice: "Your listing has been updated!"
		else
			render :edit, error: "An error has occured, your attempt to update your listing was unsuccessful!"
		end
	end

	def destroy
		@listing.destroy
		redirect_to listing_path, notice: "You have successfully removed your listing!"
	end

	private

	def set_listing
		@listing = Listing.find(params[:id])
	end

	def listing_params
		params.require(:listing).permit(
			:name,
			:description,
			:address,
			:state,
			:country,
			:number_of_beds,
			:price,
			:available_from,
			:available_to,
			:property_type
			)
	end

	def authorize_user
		redirect_to listings_path if current_user.customer? && current_user != listing.user
	end

end
