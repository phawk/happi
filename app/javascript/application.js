import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import * as ActiveStorage from "@rails/activestorage";
import "trix";
import "@rails/actiontext";
import "./channels";
import "./controllers";

Rails.start();
ActiveStorage.start();
