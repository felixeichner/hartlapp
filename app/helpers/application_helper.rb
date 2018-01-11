module ApplicationHelper

	def full_title(page_title = '')
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			page_title + ' | ' + base_title
		end
	end

	def active(controller, action, id = nil)
		"active" if current_page?(controller: controller, action: action, id: id)
	end
end
