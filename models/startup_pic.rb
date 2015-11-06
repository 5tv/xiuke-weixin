class StartupPic < ActiveRecord::Base
  mount_uploader :beauty640x960, StartupPicUploader
  mount_uploader :beauty640x1136, StartupPicUploader
  
  def beauty640x960_hash
    {
      origin: self.beauty640x960.url,
      x1200: self.beauty640x960.x1200.url,
      x1000: self.beauty640x960.x1000.url,
      x800: self.beauty640x960.x800.url,
      x600: self.beauty640x960.x600.url,
      x400: self.beauty640x960.x400.url,
      x300: self.beauty640x960.x300.url,
      x200: self.beauty640x960.x200.url,
      x150: self.beauty640x960.x150.url,
      x100: self.beauty640x960.x100.url
    }
  end

  def beauty640x1136_hash
    {
      origin: self.beauty640x1136.url,
      x1200: self.beauty640x1136.x1200.url,
      x1000: self.beauty640x1136.x1000.url,
      x800: self.beauty640x1136.x800.url,
      x600: self.beauty640x1136.x600.url,
      x400: self.beauty640x1136.x400.url,
      x300: self.beauty640x1136.x300.url,
      x200: self.beauty640x1136.x200.url,
      x150: self.beauty640x1136.x150.url,
      x100: self.beauty640x1136.x100.url        
    }
  end

  def with_virtual_attr_for_api
    self.attributes.merge(
      beauty640x1136: beauty640x1136_hash,
      beauty640x960: beauty640x960_hash
      )
  end
end
