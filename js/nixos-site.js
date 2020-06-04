$(document).ready(function () {
  $(".nixos-popover").popover({});
  $(".navbar-search a").click(function (event) {
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
  $("#packages-search button").click(function (event) {
    event.preventDefault();
    var url = "https://search.nixos.org/packages";
    url += "?query=" + $("input", $(this).parents("form")).val();
    window.location.href = url;
  });
  var qs = new URLSearchParams(window.location.search.substring(1));
  var query = qs.get("query");
  if (query !== null) {
    $(".navbar-search input").val(query);
  }
});
