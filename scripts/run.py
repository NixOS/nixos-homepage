from livereload import Server, shell
import os

server = Server()
server.watch("./*.xml", lambda: os.system("make"))
server.watch("./*.tt", lambda: os.system("make"))
server.watch("./**/*.tt", lambda: os.system("make"))
server.watch("./images/*", lambda: os.system("make"))
server.watch("./js/*", lambda: os.system("make"))
server.watch("./css/*", lambda: os.system("make"))
server.watch("./demos/*.scenario", lambda: os.system("make"))
server.watch("./site-styles/*", lambda: os.system("make"))
server.watch("./site-styles/**/*", lambda: os.system("make"))
server.watch("./site-styles/**/**/*", lambda: os.system("make"))
server.serve(root="./", port=8000)
