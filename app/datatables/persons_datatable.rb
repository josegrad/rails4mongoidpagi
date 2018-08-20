class PersonsDatatable
    delegate :params, :format_edit, :format_delete, to: :@view

    def initialize(view)
        @view = view
    end
  
    def as_json(options = {})
        {
            draw: params[:draw].to_i,
            iTotalDisplayRecords: persons.total_entries,
            iTotalRecords: persons.total_entries,
            data: data
        }
    end

private

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
        persons = Person.all.paginate(:page => page, :per_page => per_page)
        return persons
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
