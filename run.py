from livereload import Server, shell

server = Server()
server.watch("./", shell("make"))
server.serve(root="./", port=8000)
