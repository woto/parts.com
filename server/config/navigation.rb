# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  navigation.items do |primary|
    primary.item :mkey_1, t('Manufacturers'), '#', :highlights_on => /never/ do |sub_nav|
      sub_nav.item :mkey_1_1, t('Manufacturers from parts_com'), manufacturers_path, :highlights_on => /manufacturers/
      sub_nav.item :meky_1_2, t('Manufacturer synonyms'), manufacturer_synonyms_path, :highlights_on => /manufacturer_synonyms/
    end
    primary.item :mkey_2, t('Parts'), parts_path, :highlights_on => /parts/ do |sub_nav|
      sub_nav.item :mkey_2_1, t('Upload csv file'), prices_path, :highlights_on => /price/
    end
      
    primary.item :mkey_3, t('Processing'), processing_new_path
    primary.item :mkey_4, t('Delayed Job Admin'), delayed_job_admin_path
    primary.item :mkey_5, t('Proxies'), proxies_path, :highlights_on => /prox/

    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>. 
    #
    #primary.item :key_1, 'name', 'a', {}

    ## Add an item which has a sub navigation (same params, but with block)
    #primary.item :key_2, 'name', 'd', {} do |sub_nav|
    #  # Add an item to the sub navigation (same params again)
    #  sub_nav.item :key_2_1, 'name', 'g', {}
    #end

    ## You can also specify a condition-proc that needs to be fullfilled to display an item.
    ## Conditions are part of the options. They are evaluated in the context of the views,
    ## thus you can use all the methods and vars you have available in the views.
    #primary.item :key_3, 'Admin', 'n', :class => 'special', :if => Proc.new { 'current_user.admin?' }
    #primary.item :key_4, 'Account', 'i', :unless => Proc.new { 'logged_in?' }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end

end
