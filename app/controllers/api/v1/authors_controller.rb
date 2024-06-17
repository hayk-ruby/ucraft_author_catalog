class Api::V1::AuthorsController < ApplicationController
    before_action :authorize_request
    before_action :set_author, only: [:show, :update, :destroy]
    before_action :set_authors, only: [:index]
  
    def index
        render json: @authors
    end
  
    def create
        author = Author.new(author_params)
        return render json: {errors: author.errors.full_messages}, status: :bad_request unless author.save
        render json: author
    end
  
    def show
        render json: @author
    end

    def update
        is_chenged_full_name = (@author.full_name != author_params[:full_name])
        return render json: {errors: @author.errors.full_messages}, status: :bad_request unless @author.update(author_params)
        update_auther_books if is_chenged_full_name
        render json: @author
    end
  
    def destroy
        return render json: {errors: 'not deleted'}, status: :bad_request unless @author.destroy
        delete_author_books
        render json: {message: 'deleted'}, status: :accepted
    end
  

    private
  
    def set_authors
        @authors = Author.paginate_data(params)
    end
  
    def author_params
        params.permit(:full_name, :bio)
    end
  
    def set_author
        @author = Author.find_by_id(params[:id])
        return render json: {errors: 'Not found'}, status: :not_found if @author.nil?
    end
    
    def delete_author_books
        bearer = request.headers[:Authorization]

        uri = URI.parse("http://127.0.0.1:3002/api/v1/delete_auther_books")
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request.body = JSON.dump({
                    token: 'e9V3tB6vBpPavjRY6u1bdG',
                    author_id: params[:id]
                    })
        request['Authorization'] = bearer
        req_options = {
        use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end
    end

    def update_auther_books
        bearer = request.headers[:Authorization]

        uri = URI.parse("http://127.0.0.1:3002/api/v1/update_auther_books")
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request.body = JSON.dump({
                    token: 'e9V3tB6vBpPavjRY6u1bdG',
                    author_id: params[:id],
                    author_full_name: params[:full_name]
                    })
        request['Authorization'] = bearer
        req_options = {
        use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end
    end
  end