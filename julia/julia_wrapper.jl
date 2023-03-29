using Revise
using Pkg
ENV["PYTHON"] = "/home/user/miniconda3/bin/python"          
Pkg.build("PyCall")
using PyCall
