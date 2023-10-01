from cytriangle.cytriangle import CyTriangle

sample_dict = {"vertices": [[0, 0], [0, 1], [1, 1], [1, 0]]}

if __name__ == "__main__":
    test = CyTriangle(input_dict=sample_dict)
    in_test = test.get_input_as_dict()
    test.triangulate("a0.2")
    out_test = test.get_output_as_dict()
    print(in_test)
    print(out_test)
    print(test.get_voronoi_as_dict())
