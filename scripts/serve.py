import click
import livereload
import os


@click.command()
def main():
    server = livereload.Server()

    paths_to_watch = [
        "./**/*.tt",
        "./*.tt",
        "./*.xml",
        "./Makefile",
        "./css/*",
        "./demos/*.scenario",
        "./images/*",
        "./js/*",
        "./scripts/*",
        "./site-styles/*",
        "./site-styles/**/*",
        "./site-styles/**/**/*",
    ]

    for path in paths_to_watch:
        server.watch(path, lambda: os.system("make"))

    os.system("make")

    server.serve(root="./", port=os.getenv("PORT", 8000))

if __name__ == "__main__":
    main()
