import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Eagerly import all Stimulus controllers from the controllers directory
const controllers = import.meta.glob("../controllers/**/*_controller.js", {
  eager: true,
});
for (const path in controllers) {
  const controllerName = path.split("/").pop().replace("_controller.js", "");
  application.register(controllerName, controllers[path].default);
}

console.log("Vite ⚡️ Rails");
