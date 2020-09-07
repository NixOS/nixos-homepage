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

  $("[data-fullscreen-pane]").each(function () {
    var $source = $(this);
    var $pane = $(".fullscreen-pane." + $source.data("fullscreen-pane"));

    // Wire the source to present the pane
    $source.click(function (e) {
      $pane.show()[0].scrollIntoView();
      e.preventDefault();
    })

    // Add the close button, and wire it.
    var $el = $("<button class='pane-close'>Close this pane</button>");
    $el.click(function () {
      $pane.hide();
      $source[0].scrollIntoView({ block: "center" });
    });
    $pane.append($el);
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
