$(window).load(function() {
  let project = window.location.pathname.split('/')[2];
  let channel = window.location.pathname.split('/')[3];
  let unstable = $("<a/>")
    .attr("href", "/manual/" + project + "/unstable")
    .text("unstable");
  let stable = $("<a/>")
    .attr("href", "/manual/" + project + "/stable")
    .text("stable");
  let channels = $("<dl>")
    .append($("<dt/>").text("Versions"))
    .append($("<dd/>").append(unstable))
    .append($("<dd/>").append(stable));
  let current = $("<div/>")
    .click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        $(this).parent().toggleClass("opened");
    })
    .text("v: " + channel);
  let injected = $("<div/>")
    .addClass("injected-select-channels")
    .append(current)
    .append(channels);
  $("body").append(injected);
})
