module ApplicationHelper

	def format_edit(person)
		return link_to "Edit", edit_person_path(person), class: "btn btn-default"
	end

	def format_delete(person)
		return button_to "Delete", person, method: :delete, data: { confirm: "Are you sure you wish to delete #{person.first_name} #{person.last_name}?" }, class: "btn btn-danger"
	end
end
