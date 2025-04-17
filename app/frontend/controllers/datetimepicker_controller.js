import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["datePicker", "timePicker"];

  connect() {
    // Set up the date and time pickers
    this.populateDatePicker();
    this.populateTimePicker();

    // Add labels
    this.datePickerTarget.setAttribute("data-label", "Date");
    this.timePickerTarget.setAttribute("data-label", "Time Slot");

    // Add scroll event listeners
    this.datePickerTarget.addEventListener("scroll", () =>
      this.handleScroll(this.datePickerTarget)
    );
    this.timePickerTarget.addEventListener("scroll", () =>
      this.handleScroll(this.timePickerTarget)
    );

    // Add wheel event listener for smoother scrolling
    this.datePickerTarget.addEventListener(
      "wheel",
      (e) => {
        e.preventDefault();
        const scrollAmount = e.deltaY * 0.2;
        this.datePickerTarget.scrollBy({
          top: scrollAmount,
          behavior: "smooth",
        });

        clearTimeout(this.dateScrollTimeout);
        this.dateScrollTimeout = setTimeout(() => {
          this.snapToCenter(this.datePickerTarget);
        }, 150);
      },
      { passive: false }
    );

    this.timePickerTarget.addEventListener(
      "wheel",
      (e) => {
        e.preventDefault();
        const scrollAmount = e.deltaY * 0.2;
        this.timePickerTarget.scrollBy({
          top: scrollAmount,
          behavior: "smooth",
        });

        clearTimeout(this.timeScrollTimeout);
        this.timeScrollTimeout = setTimeout(() => {
          this.snapToCenter(this.timePickerTarget);
        }, 150);
      },
      { passive: false }
    );

    // Set initial centering with a delay to ensure DOM is fully rendered
    this.initialCentering();
  }

  // New method for initial centering
  initialCentering() {
    setTimeout(() => {
      // Get the first real options
      const dateOptions =
        this.datePickerTarget.querySelectorAll(".date-option");
      const timeOptions =
        this.timePickerTarget.querySelectorAll(".time-option");

      if (dateOptions.length > 0) {
        // Center the first date option
        this.scrollToElement(this.datePickerTarget, dateOptions[0]);
        dateOptions[0].classList.add("selected");
      }

      if (timeOptions.length > 0) {
        // Center the first time option
        this.scrollToElement(this.timePickerTarget, timeOptions[0]);
        timeOptions[0].classList.add("selected");
      }
    }, 100);
  }

  // Helper method to scroll an element to the center of its container
  scrollToElement(container, element) {
    if (!container || !element) return;

    const containerHeight = container.offsetHeight;
    const elementHeight = element.offsetHeight;

    // Calculate position to center the element
    const scrollPosition =
      element.offsetTop - containerHeight / 2 + elementHeight / 2;

    // Apply scroll position
    container.scrollTop = scrollPosition;
  }

  populateDatePicker() {
    // Clear existing options
    // this.datePickerTarget.innerHTML = "";

    // Create date options for the next 5 days
    const today = new Date();
    for (let i = 1; i <= 5; i++) {
      const date = new Date(today);
      date.setDate(today.getDate() + i);

      const option = document.createElement("div");
      option.className = "date-option";
      option.dataset.value = date.toISOString().split("T")[0];
      option.textContent = date.toDateString();
      this.datePickerTarget.appendChild(option);
    }
  }

  populateTimePicker() {
    // Clear existing options
    // this.timePickerTarget.innerHTML = "";

    // Create time options
    const timeSlots = [
      "10:00AM - 11:00AM",
      "11:00AM - 12:00PM",
      "12:00 PM - 1:00 PM",
      "1:00 PM - 2:00 PM",
      "2:00 PM - 3:00 PM",
      "3:00 PM - 4:00 PM",
      "4:00 PM - 5:00 PM",
    ];

    timeSlots.forEach((slot) => {
      const option = document.createElement("div");
      option.className = "time-option";
      option.dataset.value = slot;
      option.textContent = slot;
      this.timePickerTarget.appendChild(option);
    });
  }

  handleScroll(picker) {
    // Find which option is closest to the center
    const options = Array.from(
      picker.querySelectorAll(".date-option, .time-option, .empty-option")
    );
    const pickerRect = picker.getBoundingClientRect();
    const centerY = pickerRect.top + pickerRect.height / 2;

    // Remove selected class from all options
    options.forEach((opt) => opt.classList.remove("selected"));

    // Find the option closest to center
    let closestOption = null;
    let minDistance = Infinity;

    options.forEach((option) => {
      const rect = option.getBoundingClientRect();
      const distance = Math.abs(rect.top + rect.height / 2 - centerY);

      if (distance < minDistance) {
        minDistance = distance;
        closestOption = option;
      }
    });

    // Add selected class to the closest option
    if (closestOption && !closestOption.classList.contains("empty-option")) {
      closestOption.classList.add("selected");
    }
  }

  snapToCenter(picker) {
    const options = Array.from(
      picker.querySelectorAll(".date-option, .time-option")
    );
    if (options.length === 0) return;

    const pickerRect = picker.getBoundingClientRect();
    const centerY = pickerRect.top + pickerRect.height / 2;

    // Find the option closest to the center
    let closestOption = null;
    let minDistance = Infinity;

    options.forEach((option) => {
      const rect = option.getBoundingClientRect();
      const optionCenterY = rect.top + rect.height / 2;
      const distance = Math.abs(optionCenterY - centerY);

      if (distance < minDistance) {
        minDistance = distance;
        closestOption = option;
      }
    });

    if (closestOption) {
      // Calculate the scroll position to center this option
      const rect = closestOption.getBoundingClientRect();
      const targetScroll =
        picker.scrollTop +
        (rect.top - pickerRect.top) -
        (pickerRect.height / 2 - rect.height / 2);

      picker.scrollTo({
        top: targetScroll,
        behavior: "smooth",
      });

      // Mark as selected
      options.forEach((opt) => opt.classList.remove("selected"));
      closestOption.classList.add("selected");
    }
  }

  // Get the selected values for external use
  getSelectedValues() {
    const selectedDate = this.datePickerTarget.querySelector(
      ".date-option.selected"
    )?.dataset.value;
    const selectedTime = this.timePickerTarget.querySelector(
      ".time-option.selected"
    )?.dataset.value;

    return {
      date: selectedDate,
      time: selectedTime,
    };
  }
}
