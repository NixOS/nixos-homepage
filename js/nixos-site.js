$(function () {
  // Setup the responsive collapsible menu
  var $header = $("body > header");
  var $menu = $("body > header nav");
  // No need to hide the menu, it's already hidden via inline style, which is
  // the method used by jQuery.slideToggle().
  $header.append(function () {
    var $el = $("<button class='menu-toggle'>Toggle the menu</button>");
    $el.click(function () {
      $menu.slideToggle(200);
    });

    return $el;
  });

  // Allow some parts of the site to present additional information for
  // debugging purposes. E.g. responsive width identifier.
  $(".footer-copyright").dblclick(function () {
    $("body").toggleClass("-debug");
  })

  // Search widget specific JavaScript (to be removed)

  $("#learn-options-search button, #options-search button").click(function (event) {
    event.preventDefault();
    var url = "https://search.nixos.org/options";
    url += "?query=" + $("input", $(this).parents("form")).val()
    window.location.href = url;
  });

  $("#learn-packages-search button, #packages-search button").click(function (event) {
    event.preventDefault();
    var url = "https://search.nixos.org/packages";
    url += "?query=" + $("input", $(this).parents("form")).val();
    window.location.href = url;
  });
});
