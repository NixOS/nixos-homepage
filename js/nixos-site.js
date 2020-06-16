$(document).ready(function () {
  $(".nixos-popover").popover({});

  $("#learn-options-search button, #options-search button").click(function (event) {
    event.preventDefault();
    var url = window.location.protocol + "//" + window.location.host + "/nixos/options.html"
    url += "#" + $("input", $(this).parents("form")).val()
    window.location.href = url;
  });

  $("#learn-packages-search button, #packages-search button").click(function (event) {
    event.preventDefault();
    var url = window.location.protocol + "//" + window.location.host + "/nixos/packages.html"
    url += "?query=" + $("input", $(this).parents("form")).val();
    window.location.href = url;
  });
});
