module InfusionViewHelper
  
  # Convenience method for spitting out the necessary javascript include tags. Pass the name fo a component to include component-specific files.
  #
  # Examples
  # infusion_javascripts    # Returns javascript tag for the basic (minified) infusionAll.js
  # infusion_javascripts(:uploader)  # Returns the minimfied javascript tag plus additional tags required for the uploader
  #
  # Options
  # :debug => true # Rather than the minified infusionAll.js, the uncompressed copies of all infusion core javascript libriaries will be used.
  # :cache => true will tell rails to cache the javascript file (defaults to false)
  # :include_base => false will exclude the minified file, returning only links to component-specific files
  
  
  def infusion_javascripts(type = :basic, opts={})
    opts = {:include_base=>true, :cache=>false, :debug=>false}.merge!opts
    
    debug_base_paths = ["../infusion/framework/core/js/jquery.keyboard-a11y.js",
            "../infusion/framework/core/js/Fluid.js",
            "../infusion/components/inlineEdit/js/InlineEdit.js"]
    base_paths = opts[:debug] ? debug_base_paths : ['../infusion/InfusionAll.js']
    
    paths = opts[:include_base] ? base_paths : []
    
    case type
    when :default_no_jquery
      paths = ["../infusion/framework/core/js/jquery.keyboard-a11y.js", 
        "../infusion/lib/swfobject/js/swfobject.js", 
        "../infusion/lib/swfupload/js/swfupload.js", 
        "../infusion/framework/core/js/Fluid.js", 
        "../infusion/components/inlineEdit/js/InlineEdit.js", 
        "../infusion/components/inlineEdit/js/InlineEditIntegrations.js", 
        "../infusion/framework/core/js/ProgressiveEnhancement.js", 
        "../infusion/components/progress/js/Progress.js", 
        "../infusion/components/uploader/js/FileQueue.js", 
        "../infusion/components/uploader/js/SWFUploadManager.js", 
        "../infusion/components/uploader/js/Scroller.js", 
        "../infusion/components/uploader/js/Uploader.js"]
      
    when :uploader
      paths << '../infusion/framework/core/js/ProgressiveEnhancement.js'

      #<!-- Uploader dependencies; these will be merged into a new Uploader.js at the end -->
      paths << "infusion/lib/swfobject/js/swfobject.js"
      paths << "infusion/lib/swfupload/js/swfupload.js"
      paths << "infusion/components/uploader/js/FileQueue.js"
      paths << "infusion/components/uploader/js/SWFUploadManager.js"
      paths << "infusion/components/uploader/js/Scroller.js"
      paths << "infusion/components/uploader/js/Uploader.js"
    end
    
    if opts[:extras] 
      if opts[:extras].include?(:fckeditor)
        paths << '../infusion/tests/manual-tests/lib/fckeditor/fckeditor.js'
      end
      if opts[:extras].include?(:inline_editor_integrations)
        paths << "../infusion/components/inlineEdit/js/InlineEditIntegrations.js"
      end
    end
    
    if opts[:render_html] == false
      paths << {:cache=>opts[:cache], :plugin=>"fluid-infusion"}
      result = paths
    else
      result = ""
      paths.each do |path|
        result << javascript_include_tag(path, :cache=>opts[:cache], :plugin=>"fluid-infusion")
      end
    end
    return result
  end
  
  # Convenience method for spitting out the necessary stylesheet link tags.  Pass the name fo a component to include component-specific files.
  #
  # Examples
  # infusion_stylesheets    # Returns tags for the common stylesheets used by infusion components
  # infusion_stylesheets(:uploader)  # Returns tags for the common stylesheets plus additional stylesheets required for the uploader
  #
  # Options
  # :include_base => false will exclude the common stylesheets, returning only links to component-specific stylesheets
  
  def infusion_stylesheets(type = :basic, opts={})
    opts = {:include_base=>true, :cache=>false}.merge!opts
    base_paths = ['../infusion/framework/fss/css/fss-reset.css', '../infusion/framework/fss/css/fss-layout.css']
    
    paths = opts[:include_base] ? base_paths : []
    case type
    when :uploader
      paths << '../infusion/components/uploader/css/Uploader.css'
    when :inline_edit
      ["../infusion/framework/fss/css/fss-theme-mist.css",
        "../infusion/framework/fss/css/fss-theme-hc.css",
        "../infusion/components/inlineEdit/css/InlineEdit.css"].each {|path| paths << path}
    end
    
    result = ""
    paths.each do |path|
      result << stylesheet_link_tag(path, :plugin=>"fluid-infusion")
    end
    return result
  end
  
end