$(document).ready(function () {
  $(".nixos-popover").popover({});

  $("#learn-options-search button, #options-search button").click(function (event) {
    event.preventDefault();
    var url = "https://search.nixos.org";
    if ($(this).hasClass("search-options")) {
      url += "/options";
      url += "?query=" + $("input", $(this).parents("form")).val()
    } else {
      url += "/packages"
      url += "?query=" + $("input", $(this).parents("form")).val();
    }
    window.location.href = url;
  });

  $("#learn-packages-search button, #packages-search button").click(function (event) {
    event.preventDefault();
    var url = "https://search.nixos.org/packages";
    url += "?query=" + $("input", $(this).parents("form")).val();
    window.location.href = url;
  });
});
