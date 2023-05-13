import click
import toml

TEMPLATE = """
    <li>
      <a href="{url}">
        <div>
          <img alt="{name}" src="{logo}" />
        </div>
        <h2>{name}</h2>
        {locations}
        {description}
      </a>
    </li>
"""

@click.command()
@click.option("--input", required=True, type=str)
def main(input):

    with open(input) as f:
        providers = toml.load(f)["commercial-provider"]

    for provider in providers:
        provider["name"] = provider["name"][:50]

        provider["description"] = provider["description"][:400]

        if len(provider["locations"]) > 0:
            provider["locations"] = "".join([
              "<ul>",
              "".join([
                  f"<li>{location}</li>"
                  for location in provider["locations"]
              ]),
              "</ul>",
            ])
        else:
            provider["locations"] = ""

        click.echo(TEMPLATE.format(**provider), nl=False)


if __name__ == "__main__":
    main()
