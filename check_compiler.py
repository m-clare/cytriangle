from distutils.ccompiler import new_compiler

def print_compiler_settings():
    compiler = new_compiler()

    print("CCompiler Executable Options")
    print(f"Compiler Type: {compiler.compiler_type}")
    # print(f"Linker Type: {compiler.linker_type}")


    executable_options = compiler.executables
    print(executable_options)
    for name, value in executable_options.items():
        print(f"{name}: {value}")

if __name__ == "__main__":
    print_compiler_settings()