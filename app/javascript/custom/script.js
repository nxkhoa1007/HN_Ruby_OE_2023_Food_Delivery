document.addEventListener('turbo:load', function() {
  const input = document.querySelector("#cost");
  input.addEventListener("input", () => {
      let inputValue = input.value;
      inputValue = inputValue.replace(/[^0-9]/g, '');
      if (!isNaN(inputValue)) {
        inputValue = Number(inputValue).toLocaleString();
        input.value = inputValue;
      }
  });
});
