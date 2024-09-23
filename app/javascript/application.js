// Entry point for the build script in your package.json
import Rails from "@rails/ujs";  // ここで Rails UJS をインポート
Rails.start();  // Rails UJS を初期化

import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
