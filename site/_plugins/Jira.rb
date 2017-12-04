module Jekyll
  class JiraTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      @issue_number = text.strip
      super
    end

    def render(context)
      site = context.registers[:site]
      issue = site.config["jira_key"] + "-" + @issue_number
      url = site.config["jira_base_url"] + "/" + issue
      "[<a href='" + url + "'>" + issue + "</a>]"
    end
  end
end

Liquid::Template.register_tag('jira', Jekyll::JiraTag)
