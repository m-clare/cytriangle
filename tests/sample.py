from cytriangle.cytriangle import CyTriangle

sample_dict = {'point_list': [[0, 0], [0, 1], [1, 1], [1, 0]]}

if __name__ == "__main__":
    test = CyTriangle(input_dict=sample_dict)
    in_test = test.get_input()
    test.triangulate()
    out_test = test.get_output()
    print(in_test)
    print(out_test)
    print(test.get_voronoi_output())
