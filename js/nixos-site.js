$(document).ready(function () {
  $(".nixos-popover").popover({});
  $(".navbar-search a").click(function (event) {
    event.preventDefault();
    var url = window.location.protocol + "//" + window.location.host + "/nixos";
    if ($(this).text() === "Options") {
      url += "/options.html";
      url += "#" + $("input", $(this).parents("form")).val()
    } else {
      url += "/packages.html"
      url += "?channel=nixos-" + $(document.body).data('latest-nixos-series');
      url += "&query=" + $("input", $(this).parents("form")).val();
    }
    window.location.href = url;
  });
  $("#packages-search button").click(function (event) {
    event.preventDefault();
    var url = window.location.protocol + "//" + window.location.host + "/nixos/packages.html"
    url += "?channel=nixos-" + $(document.body).data('latest-nixos-series');
    url += "&query=" + $("input", $(this).parents("form")).val();
    window.location.href = url;
  });
  var qs = new URLSearchParams(window.location.search.substring(1));
  var query = qs.get("query");
  if (query !== null) {
    $(".navbar-search input").val(query);
  }
});
