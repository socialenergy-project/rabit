class BootstrapLeft < SimpleNavigation::Renderer::List

  def options_for(item)
    res = link_options_for(item)
    if !item.selected? and res[:class].split.include? 'nav-link-collapse'
      res[:class] += " collapsed"
    end
    res
  end

  def render_sub_navigation_for(item)
    opt = options.deep_dup
    item.sub_navigation.dom_class += " show" if item.selected?
    item.sub_navigation.render(opt)
  end
end

