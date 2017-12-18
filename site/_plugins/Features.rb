module Jekyll
  class OkTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      "<i class='glyphicon glyphicon-ok' style='color: #00d000;'></i>"
    end
  end

  class ErrorTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      "<i class='glyphicon glyphicon-remove' style='color: #d00000;'></i>"
    end
  end

  class WarningTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      "<i class='glyphicon glyphicon-minus' style='color: #efcb00;'></i>"
    end
  end
end

Liquid::Template.register_tag('ok', Jekyll::OkTag)
Liquid::Template.register_tag('err', Jekyll::ErrorTag)
Liquid::Template.register_tag('warn', Jekyll::WarningTag)
