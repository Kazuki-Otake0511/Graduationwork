class ImageUploader < CarrierWave::Uploader::Base
   # 保存先の指定。デフォルトではファイルシステムに保存される
   storage :file

   # アップロードされたファイルを保存するディレクトリを指定
   def store_dir
     "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
   end
 
   # 許可するファイルの拡張子を制限
   def extension_whitelist
     %w(jpg jpeg gif png)
   end

   # 画像のサイズ制限（例: 1MBまで）
   def size_range
     1..1.megabytes
   end
   
end
