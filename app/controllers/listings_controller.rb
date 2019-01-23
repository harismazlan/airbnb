class ListingsController < ApplicationController
	before_action :set_listing, except: [:index, :new, :create]
	before_action :require_login

	def index
		@listings = Listing.all
		@listings = @listings.state(params[:state]) if params[:state].present?
    	@listings = @listings.country(params[:country]) if params[:country].present?
    	@listings = @listings.available_from(params[:available_from]) if params[:available_from].present?
    	@listings = @listings.available_to(params[:available_to]) if params[:available_to].present?

    	if !params[:min].present? && !params[:max].present?
	      @listings = @listings.where(price: 0..Listing.maximum("price"))
	    elsif params[:min].present? && !params[:max].present?
	      @listings = @listings.where(price: params[:min].to_i..Listing.maximum("price"))
	    elsif params[:max].present? && !params[:min].present?
	      @listings = @listings.where(price: 0..params[:max].to_i)
	    else
	      @listings = @listings.where(price: params[:min].to_i..params[:max].to_i)
	    end



		@listings = @listings.order(id: :asc).page(params[:page])

		# respond_to do |format|
		# 	format.html {render action: "index"}
		# 	format.js
		# end
	end

	def new
		@listing = Listing.new
	end

	def create
		@listing = current_user.listings.new(listing_params)
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
			:property_type,
			:images => []
			)
	end

	def authorize_user
		redirect_to listings_path if current_user.customer? && current_user != listing.user
	end

	def verify
        if current_user.superadmin? || current_user.moderator?
            @listing.update(verified: true)
            redirect_to listing_path(@listing.id)
        else
            redirect_to "/"
            flash[:alert] = "NO"
        end
    end

end
