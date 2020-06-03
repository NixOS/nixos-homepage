import click
import colorama
import json
import time

CLEAR = "\033[2J\033[1;1H"


def clear(t, t_step, chars="", color=None):
    t += 3 * t_step
    echo([t, "o", CLEAR])
    return t


def echo(item):
    click.echo(json.dumps(item))


def echo_line_all(t, t_step, chars, color=None, nl=False):
    if color:
        chars = color + chars
    echo([t, "o", chars + colorama.Style.RESET_ALL])
    echo([t, "o", "\r\n"])
    return t


def echo_line(t, t_step, chars, color=None, nl=False):
    chars = list(chars) + [colorama.Style.RESET_ALL]
    if color:
        chars = [color] + chars
    for char in chars:
        t += t_step
        if not color and char == "#":
            char = colorama.Style.BRIGHT + char
        echo([t, "o", char])
    if nl:
        t += (3 * t_step)
        echo([t, "o", "\r\n"])
    return t


def echo_console_line(t, t_step, chars, color=None):
    t += t_step
    echo([t, "o", "$ "])
    t += (3 * t_step)
    t = echo_line(t, t_step, chars, color=color, nl=True)
    return t


def echo_nix_shell_line(t, t_step, chars, color=None):
    t += t_step
    echo([t, "o", colorama.Fore.GREEN + "(nix-shell) $ " + colorama.Style.RESET_ALL])
    t += (3 * t_step)
    t = echo_line(t, t_step, chars, color=color, nl=True)
    return t


@click.command()
@click.option("--version", default=2)
@click.option("--width", default=77)
@click.option("--height", default=20)
@click.option("--timestamp", default=int(time.time()))
@click.option("--env-file", type=click.File(), default=None)
@click.option("--step", type=float, default=0.10)
@click.argument("scenario", type=click.File())
def main(version,
         width,
         height,
         timestamp,
         env_file,
         step,
         scenario,
         ):

    if env_file is None:
        env = {"SHELL": "bash", "TERM": "xterm"}
    else:
        with open(env_file) as f:
            env = json.load(f)

    # print header
    echo({
        "version": version,
        "width": width,
        "height": height,
        "timestamp": timestamp,
        "env": env,
    })

    # print scenario
    t = 0.0
    for line in scenario.readlines():

        # skip lines starting with "#"
        if line.startswith("#"):
            continue

        color = None
        echo_fn = None
        line = line.rstrip()

        # lines starting with "$ " display as console lines
        if line.startswith("$ "):
            line = line[len("$ "):]
            echo_fn = echo_console_line

        elif line.startswith("(nix-shell) $ "):
            line = line[len("(nix-shell) $ "):]
            echo_fn = echo_nix_shell_line

        # lines starting with "--" will clear display
        elif line.startswith("--"):
            echo_fn = clear

        # everything else skip
        else:
            echo_fn = echo_line_all

        # making everything after first " # " brighter
        if " # " in line:
            tmp = line.split(" # ", 1)
            line = tmp[0]
            if len(tmp) > 1:
                line += colorama.Style.BRIGHT + " # " + tmp[1]

        if not line.strip():
            t += 3 * step
            continue

        if echo_fn:
            t = echo_fn(t, step, line, color)



if __name__ == "__main__":
    main()

# vi:ft=python
