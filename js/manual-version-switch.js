$(window).load(function() {
  let project = window.location.pathname.split('/')[2];

  function mkItem(name, version) {
    return $("<a/>")
      .attr("href", "/manual/" + project + "/" + name)
      .text(name + " (" + version + ")");
  }

  function mkItems(title, items) {
    let el = $("<dl>")
      .append($("<dt/>").text(title));
    items.forEach(function(item) {
      el.append($("<dd/>").append(mkItem(item.channel, item.version)))
    });
    return el;
  }

  let plus = $("<i class=\"fa fa-plus\" aria-hidden=\"true\"></i>");
  let minus = $("<i class=\"fa fa-minus\" aria-hidden=\"true\"></i>").hide();
  let selected = $("<span>v: " + window.location.pathname.split('/')[3] + "</span>");
  let header = $("<div/>")
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
    .append([selected, " ", plus, minus]);

  let injected = $("<div/>")
    .addClass("injected-select-manual")
    .append(header)
    .append(mkItems("Channels", $("body").data(project + '-channels')));

  $("body").append(injected);
})
