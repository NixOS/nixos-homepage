$(function () {
  // Special "pseudo-global" variable to track whether we are synthetically
  // activating an event. In that case some semantics are different.
  var $$synthetic = false;

  // Custom event types
  var paneOpenEvent = new Event("paneOpen");
  var paneCloseEvent = new Event("paneClose");

  // All known panes
  var panesRegistry = [];

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

  var sanitizeIdentifier = function (name) {
    return name.toLowerCase()
      .replace(/[^a-z0-9]/g, "-") // Any non-alnum is replaced by a -
      .replace(/-+/g, "-")        // Any sequence of dashes replaced by only one
      .replace(/^-/, "")          // Starting dashes removed
      .replace(/-$/, "")          // And ending dashes removed
    ;
  };

  // Allow some parts of the site to present additional information for
  // debugging purposes. E.g. responsive width identifier.
  function setDebug(debug) {
    localStorage.setItem("DEBUG", JSON.stringify(debug));
    if (debug) {
      if (!$('body').hasClass('-debug')) {
        $("body").addClass("-debug");
      }
    } else {
      if ($('body').hasClass('-debug')) {
        $("body").removeClass("-debug");
      }
    }
  }
  setDebug(JSON.parse(localStorage.getItem("DEBUG")));
  $(".footer-copyright").dblclick(function() {
    setDebug(!JSON.parse(localStorage.getItem("DEBUG")));
  });

  $(".pane-asciinemaplayer").each(function () {
    var player = $(this).find("asciinema-player")[0];

    this.addEventListener("paneOpen", function (e) {
      player.play();
    });

    this.addEventListener("paneClose", function (e) {
      player.pause();
    });
  });

  $("[data-fullscreen-pane]").each(function () {
    var $source = $(this);
    var $pane = $($source.attr("href"));
    var pane = $pane[0];

    panesRegistry.push(pane);

    // Wire the source to present the pane
    $source.click(function (e) {
      $$synthetic = true;
      $(panesRegistry).find(".pane-close").click();
      $$synthetic = false;
      $pane.show();
      pane.scrollIntoView({ block: "center" });
      pane.dispatchEvent(paneOpenEvent);
    });

    // Add the close button, and wire it.
    var $close = $("<button class='pane-close'>Close this pane</button>");
    $close.click(function () {
      $pane.hide();
      $source[0].scrollIntoView({ block: "center" });
      pane.dispatchEvent(paneCloseEvent);
      if (!$$synthetic) {
        history.replaceState(null, null, " ");
      }
    });
    $($pane).children().first().append($close);
  })

  // Make a whole element act as if the first link or button was clicked.
  $(".clickable-whole").each(function () {
    var $link = $($(this).find("a, button")[0]);

    // Make the whole thing act as if it was clicked.
    $(this).on("click", function (event) {
      $link[0].click();
    });
  });

  /* `.collapse` component
   *
   * Read documentation at ../site-styles/components/collapse.less
   */
  $(".collapse").each(function () {
    var $collapse = $(this);
    var sectionName = $collapse.parents("section").attr("class") + "-";
    var $articles = $("div > article", $collapse);
    var $navItems = $("<ul>");

    $articles.each(function () {
      var $article = $(this);
      var $header = $article.children("h2");

      // Generate an identifier, in case it's needed.
      var articleId = sanitizeIdentifier("collapse-article-" + sectionName + $header.text());

      // But prefer the existing ID.
      if ($article.attr("id")) {
        articleId = $article.attr("id");
      }
      else {
        console.warn("WARNING: collapse section `" + articleId + "` uses generated name.");
      }

      // Create a link to be used in the left-hand side navigation.
      var $navLink = $("<a />").attr("href", "#" + articleId);

      $navLink.on("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        var $this = $(this);

        // unselect all selected navigation buttons
        $("li", $navItems).removeClass("-selected");

        // select the link you clicked on
        $this.parent().addClass("-selected");

        // hide all content
        $("article", $collapse).removeClass("-expanded");

        // show the content of the link you clicked on
        $article.addClass("-expanded");

        // This looks dumb, but if we don't override the native behaviour we
        // get scrolled just past the tabs...
        // So no scroll, and we control the URL.
        if (!$$synthetic) {
          history.pushState(null, null, $this.attr('href'));
        }
      });

      // Create the actual navigation element.
      var $navItem = $header
        .clone()             // Clone the header
        .wrapInner($navLink) // Wrap its contents with the previously created link
        .wrapInner("<li/>")  // Then wrap *that* with a <li>
        .children();         // And take what we just created
      $navItems.append($navItem);

      // Wrap h2 title with a link which points to the article
      var $narrowLink = $header.wrap($("<a class='article-title' />")).parent();
      $narrowLink.attr("href", "#" + articleId);
      $narrowLink.on("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        $header.parents("article").toggleClass("-expanded");
        // This looks dumb, but if we don't override the native behaviour we
        // get scrolled just past the tabs...
        // So no scroll, and we control the URL.
        if (!$$synthetic) {
          history.pushState(null, null, $(this).attr('href'));
        }
      });

      // add linkId to the article
      $header.parents("article").attr("id", articleId);
    });

    // prepend the "desktop" navigation
    $nav = $("<nav/>");
    $collapse.prepend($nav);
    $nav.append($navItems);

    // select the first one when not in url
    if (!window.location.hash.startsWith("#collapse-article-" + sectionName)) {
      $("nav > ul > li > a", $collapse).first().click();
    }
  });

  // Terrible days counter
  $(".countdown-timer").each(function () {
    var $this = $(this);
    var when = new Date($this.data("date"));

    function updateCounter() {
      var today = new Date();
      var left = when - today;  // in miliseconds

      var stale = (new Date($this.data("stale")) - today) < 0;
      if (stale) {
        $($this.data("stale-hide")).remove();
      }

      var current = left < 0;
      if (current) {
        $this.text(
          $this.data("current")
        );
      } else {
        var left_date = new Date(left);
        var days = Math.round(left / (24*60*60*1000));
        if (days < 10) {
          days = "0" + days;
        }
        $(".counter-days", $this).text(days);
        var hours = left_date.getHours();
        if (hours < 10) {
          hours = "0" + hours;
        }
        $(".counter-hours", $this).text(hours);
        var minutes = left_date.getMinutes();
        if (minutes < 10) {
          minutes = "0" + minutes;
        }
        $(".counter-minutes", $this).text(minutes);
        var seconds = left_date.getSeconds();
        if (seconds < 10) {
          seconds = "0" + seconds;
        }
        $(".counter-seconds", $this).text(seconds);
      }
    }

    if (isNaN(new Date($this.data("date")))) {
      $this.hide();
    } else {
      updateCounter();
      setInterval(updateCounter, 1000);
    }
  })

  //
  // Page-specific JS
  //

  /*
   * Amazon region selection
   */
  $(".download-amazon").each(function () {
    var $root = $(this);
    var amazonUrl = $(".download-buttons a", $root).attr("href");
    var selectRegion = function () {
      $(".selected", $root).removeClass("selected");
      var region = $("select", $root).val();
      var ami = $("#" + region, $root)
        .addClass("selected")
        .find("code").text();
      $(".download-buttons a", $root)
        .attr("href", amazonUrl + "?region=" + region + "#launchAmi=" + ami);
    };
    $("select", $root).on("change", selectRegion);
    selectRegion();
  });

  //
  // Some late initialization stuff
  //

  // Activate the link for which the anchor matches. Hopefully changing the tab
  // or opening the relevant pane.
  var handleNavigation = function(event) {
    $$synthetic = true;
    $("[href='"+window.location.hash+"']").click()
    $$synthetic = false;
  };
  window.onpopstate = handleNavigation;

  // Assume a fresh navigation activates our handler.
  // This way tabs and panes are active as intended.
  handleNavigation();

});
