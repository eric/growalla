module Gowalla
  class ActivityActor
    include SAXMachine
    include Feedzirra::FeedUtilities

    element :id
    element :title

    element :link, :as => :url, :value => :href, :with => {:rel => "alternate"}
    element :link, :as => :image_url, :value => :href, :with => {:rel => "image"}
  end


  class ActivityObject
    include SAXMachine
    include Feedzirra::FeedUtilities

    element :id
    element :title
    element 'georss:point', :as => :georss_point

    element :link, :as => :url, :value => :href, :with => {:rel => "alternate"}
    element :link, :as => :image_url, :value => :href, :with => {:rel => "image"}
  end

end

class Feedzirra::Parser::AtomEntry
  elements "activity:actor", :as => 'actors', :class => Gowalla::ActivityActor
  def actor; actors.first; end

  elements "activity:object", :as => 'activity_objects', :class => Gowalla::ActivityObject
  def activity_object; activity_objects.first; end
  alias_method :location, :activity_object
end

