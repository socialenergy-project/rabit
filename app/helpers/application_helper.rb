module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ?
                    (sort_direction == "asc")?
                        "fa fa-arrow-up"
                        : "fa fa-arrow-down"
                    : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to "<i class='#{css_class}'></i>#{title}".html_safe, {sort: column, direction: direction, category: params[:category]}
  end

  def setup_ecc_type(ecc_type)
    3.times {ecc_type.ecc_terms.map(&:ecc_factors).map(&:build) }
    3.times { ect = ecc_type.ecc_terms.build; 3.times { ect.ecc_factors.build } }
    ecc_type
  end
end
