class BootstrapBreadcrumbs < SimpleNavigation::Renderer::Base
  def render(item_container)
    content_tag :ol, li_tags(item_container).join(join_with), {
        id: item_container.dom_id,
        class: "breadcrumb"
    }
  end

  protected

  def li_tags(item_container)
    item_container.items.each_with_object([]) do |item, list|
      next unless item.selected?

      if include_sub_navigation?(item)
        options = { method: item.method, class: 'breadcrumb-item' }.merge(item.html_options.except(:class, :id))
        list << content_tag(:li, link_to(item.name, item.url), options)
        list.concat li_tags(item.sub_navigation)
      else
        list << content_tag(:li, item.name, { class: 'breadcrumb-item active' })
      end
    end
  end

  def join_with
    @join_with ||= options[:join_with] || ''.html_safe
  end
end

