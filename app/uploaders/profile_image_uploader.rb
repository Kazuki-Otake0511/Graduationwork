class ProfileImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  # ストレージの設定: ローカルファイルに保存する場合
  storage :file
  # リモートに保存する場合は、上記をコメントアウトし、下記を使用
  # storage :fog

  # アップロードされたファイルが保存されるディレクトリを指定
  # "uploads/[モデル名]/[カラム名]/[モデルID]" の形式で保存
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # アップロード可能なファイル拡張子の許可リスト
  def extension_allowlist
    %w(jpg jpeg gif png)
  end

   # 画像をアップロード時にリサイズする
   process resize_to_fit: [200, 200]  # 200x200にリサイズ（必要なサイズに変更）

  # アップロードされたファイルのサムネイルバージョンを作成
  version :thumb do
    process resize_to_fit: [50, 50]  # サムネイルを50x50にリサイズ
  end
  # def filename
  #   "custom_name.jpg" if original_filename
  # end
end
