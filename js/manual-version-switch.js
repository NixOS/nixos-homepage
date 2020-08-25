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
  let plus = $("<i class=\"fa fa-plus\" aria-hidden=\"true\"></i>");
  let minus = $("<i class=\"fa fa-minus\" aria-hidden=\"true\"></i>").hide();
  let currentVersion = $("<span>v: " + channel + "</span>");
  let current = $("<div/>")
    .click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      let wrapper = $(this).parent();
      wrapper.toggleClass("opened");
      if (wrapper.hasClass("opened")) {
        $(".fa-plus", this).hide()
        $(".fa-minus", this).show()
      } else {
        $(".fa-plus", this).show()
        $(".fa-minus", this).hide()
      }
    })
    .append([currentVersion, " ", plus, minus]);
  let injected = $("<div/>")
    .addClass("injected-select-channels")
    .append(current)
    .append(channels);
  $("body").append(injected);
})
