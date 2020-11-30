from livereload import Server, shell
import os

server = Server()
server.watch("./", lambda: os.system("make"))
server.serve(root="./", port=8000)
