// IMPORTANT! We need to place this script at the bottom of the body

(function() {

  let project = window.location.pathname.split('/')[2];

  function createElement(tag, attrs, text) {
    let el = document.createElement(tag);

    if (text) {
      el.appendChild(document.createTextNode(text));
    }

    if (attrs) {
      attrs.forEach(function (attr) {
        el.setAttribute(attr[0], attr[1]);
      });
    }

    return el;
  }


  function mkItem(name, version) {
    let versionParts = version.split("pre");
    let cleanedVersion;
    if (versionParts.length == 1) {
      cleanedVersion = version;
    } else {
      cleanedVersion = versionParts[0] + "pre";
    }
    return createElement(
      "a",
      [
        [ "style", "color: #FFFFFF;" +
                   "font-weight: bold;" +
                   "text-decoration: none;"],
        ["href", "/manual/" + project + "/" + name]
      ],
      name + " (" + cleanedVersion + ")"
    );
  }

  function mkItems(title, items) {
    let dt = createElement(
      "dt",
      [
        ["style", "color: #999999;"]
      ],
      title
    );

    let el = createElement(
      "dl",
      [
        ["style", "width: 240px;" +
                  "margin: 0 0 1em 0;" +
                  "display: none;"]
      ]
    );
    el.appendChild(dt)

    let dd;
    items.forEach(function (item) {
      dd = createElement(
        "dd",
        [
          ["style", "display: inline-block;" +
                    "margin-left: 1em;"]
        ]
      );
      dd.appendChild(mkItem(item.channel, item.version));
      el.appendChild(dd);
    });

    return el;
  }

  function toggleVisibility(e) {
    e.preventDefault();
    e.stopPropagation();

    let [plus, minus] = this.getElementsByTagName("strong");
    let channels = this.parentNode.getElementsByTagName("dl")[0];

    if (plus.getAttribute("style") === "display: none;") {
      plus.removeAttribute("style");
      minus.setAttribute("style", "display: none;");
      channels.setAttribute("style", channels.getAttribute("style") + "display: none;")
    } else {
      plus.setAttribute("style", "display: none;");
      minus.removeAttribute("style");
      channels.setAttribute("style", channels.getAttribute("style").replace("display: none;", ""));
    }
  }

  let plus = createElement(
    "strong",
    [
      ["aria-hidden", "true"]
    ],
    "\uFF0B"
  );
  let minus = createElement(
    "strong",
    [
      ["style", "display: none;"],
      ["aria-hidden", "true"]
    ],
    "\uFF0D"
  );
  let selected = createElement(
    "span",
    [],
    ("v: " + window.location.pathname.split('/')[3])
  );
  
  let header = createElement(
    "div",
    [
      ["style", "text-align: right;" +
                "cursor: pointer;"]
    ]
  );
  [selected, document.createTextNode(" "), plus, minus].forEach(function(item) {
    header.appendChild(item);
  });
  header.onclick = toggleVisibility;

  let body = document.getElementsByTagName('body')[0];

  let channels = mkItems(
    "Channels:", 
    JSON.parse(body.getAttribute("data-" + project + "-channels"))
  )

  let wrapper = createElement(
    "div",
    [
      ["style", "background: #333333;" +
                "color: #FFFFFF;" +
                "padding: 0.5em 1em;" +
                "position: fixed;" +
                "bottom: 0.5em;" +
                "right: 0.5em;" +
                "font-size: 0.8em;"]
    ]
  );
  wrapper.appendChild(header);
  wrapper.appendChild(channels);

  body.appendChild(wrapper);

})();
