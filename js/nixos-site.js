$.fn.shuffleChildren = function() {
  $.each(this.get(), function(index, el) {
      var random = function(s = Date.now()) {
        return function() {
            s = Math.sin(s) * 10000;

            return s - Math.floor(s);
        };
      };

      var $el = $(el);
      var $find = $el.children();

      $find.sort(function() {
          return 0.5 - random((new Date).getHours());
      });

      $el.empty();
      $find.appendTo($el);
  });
};

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

  // Takes a string and splits on the non-number components.
  // The number components are used just like: Date.UTC(...args)
  var fromUTCString = function (str) {
    var args = str.split(/[^0-9]+/);
    // Months are 0-indexed... ugh
    if (args.length > 1) {
      args[1] = args[1]-1;
    }
    return new Date(Date.UTC.apply(null, args));
  }

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
    // Make the whole thing act as if it was clicked.
    $(this).on("click", function () {
      $(this).find("a, button").first()[0].click();
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

      // First create all elements we lack

      // Create a link to be used in the left-hand side navigation.
      var $navLink = $("<a />").attr("href", "#" + articleId);

      // Create the actual navigation element.
      var $navItem = $header
        .clone()             // Clone the header
        .wrapInner($navLink) // Wrap its contents with the previously created link
        .wrapInner("<li/>")  // Then wrap *that* with a <li>
        .children();         // And take what we just created
      $navItems.append($navItem);

      // Update to point to the newly-wrapped element.
      $navLink = $navItem.children();

      // Local function to synchronize tab navigation.
      var selectCurrentTab = function () {
        // unselect all selected navigation buttons
        $("li", $navItems).removeClass("-active");

        // select the link you clicked on
        $navItem.addClass("-active");

        // hide all content (in tabs view)
        $("article", $collapse).removeClass("-selected");

        // show the content of the link you clicked on
        $article.addClass("-selected");
      };

      // Wrap h2 title with a link which points to the article
      var $narrowLink = $header.wrap($("<a class='article-title' />")).parent();
      $narrowLink.attr("href", "#" + articleId);

      // Then plug events

      // On the "tab" link
      $navLink.on("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        var $this = $(this);
        selectCurrentTab();

        if (!$$synthetic) {
          // Hide all contents in the collapsible view
          $("article", $collapse).removeClass("-expanded");
          $article.addClass("-expanded");
        }

        // This looks dumb, but if we don't override the native behaviour we
        // get scrolled just past the tabs...
        // So no scroll, and we control the URL.
        if (!$$synthetic) {
          history.pushState(null, null, $this.attr('href'));
        }
      });

      // On the "collapsible" header
      $narrowLink.on("click", function (e) {
        e.preventDefault();
        e.stopPropagation();

        // Expand the section on the collapsible side
        $article.toggleClass("-expanded");

        // And synchronize tab navigation
        selectCurrentTab();

        // This looks dumb, but if we don't override the native behaviour we
        // get scrolled just past the tabs...
        // So no scroll, and we control the URL.
        if (!$$synthetic) {
          history.pushState(null, null, $(this).attr('href'));
        }
      });

      // add linkId to the article
      $article.attr("id", articleId);
    });

    // prepend the "desktop" navigation
    var $nav = $("<nav/>");
    $collapse.prepend($nav);
    $nav.append($navItems);

    // Activate the first navigation link, always.
    $$synthetic = true;
    // Activate the tab side of the component.
    // This way the first item is implicitly open.
    $navItems.children().first().find("a").click();
    $$synthetic = false;
  });

  // Terrible days counter
  $(".countdown-timer").each(function () {
    var $this = $(this);
    var staleDate = fromUTCString($this.data("stale"))
    var when = fromUTCString($this.data("date"));

    function updateCounter() {
      var now = new Date();
      var left = when - now;  // in miliseconds

      var stale = (staleDate - now) < 0;
      if (stale) {
        $($this.data("stale-hide")).remove();
      }

      var current = left < 0;
      if (current) {
        $this.text(
          $this.data("current")
        );
      } else {
        var days = Math.floor(left / (24*60*60*1000));
        if (days < 10) {
          days = "0" + days;
        }
        $(".counter-days", $this).text(days);
        var hours = Math.floor(left / (60*60*1000)) % 24;
        if (hours < 10) {
          hours = "0" + hours;
        }
        $(".counter-hours", $this).text(hours);
        var minutes = Math.floor(left / (60*1000)) % 60;
        if (minutes < 10) {
          minutes = "0" + minutes;
        }
        $(".counter-minutes", $this).text(minutes);
        var seconds = Math.floor(left / (1000)) % 60;
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
      var ami = $("#download-amazon-" + region, $root)
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

  $("section.community-commercial-support > ul").shuffleChildren();
});
