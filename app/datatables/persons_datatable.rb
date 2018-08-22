class PersonsDatatable
    delegate :params, :format_edit, :format_delete, to: :@view

    include Pagy::Backend

    def initialize(view)
        @view = view
    end
  
    def as_json(options = {})
        {
            draw: params[:draw].to_i,
            iTotalDisplayRecords: persons.size,
            iTotalRecords: persons.size,
            data: data
        }
    end

private

# in your controller: override the pagy_get_vars method so it will call your cache_count method
def pagy_get_vars(collection, vars)
  { count: cache_count(collection),
    page: params[vars[:page_param]||Pagy::VARS[:page_param]] }.merge!(vars)
end

# add Rails.cache wrapper around the count call
def cache_count(collection)
    puts ".."
    puts collection.inspect
    puts "--"
    puts collection.metadata
  cache_key = "pagy-#{collection.model.name}:#{collection.to_sql}"
  Rails.cache.fetch(cache_key, expires_in: 20 * 60) do
   collection.count(:all)
  end
end

    def data
        persons.each.map do |person|
            [
                person.first_name,
                person.last_name,
                person.email,
                person.notes,
                format_edit(person),
                format_delete(person)
            ]
        end
    end

    def persons
        #pers = Person.all.paginate(:page => page, :per_page => per_page)
        pers = pagy(Person.all, page: page, items: per_page )
        return pers.last
    end
  
    def page
        params[:start].to_i/per_page + 1
    end

    def per_page
        params[:length].to_i > 0 ? params[:length].to_i : 10
    end

    def search
        match = params[:search][:value]
        match.presence || false
    end
  
    def sort_column
        columns = ["", "", "", "", ""]
        columns[params[:order]['0'][:column].to_i]
    end

    def sort_direction
        params[:order]['0'][:dir] == "desc" ? "desc" : "asc"
    end
end
