import pytest
from cytriangle import CyTriangle

simple_input = {'point_list': [[0, 0], [0, 1], [1, 1], [1, 0]]}

def test_simple_triangle_point_input():
    test = CyTriangle(input_dict=simple_input)
    assert test.get_input_as_dict() == {'point_list': [[0.0, 0.0], [0.0, 1.0], [1.0, 1.0], [1.0, 0.0]]}

def test_simple_triangle_area():
    test = CyTriangle(input_dict=simple_input)
    test.triangulate('a0.2')
    output = test.get_output_as_dict()
    assert output['point_list'] == [[0.0, 0.0], [0.0, 1.0], [1.0, 1.0], [1.0, 0.0], [0.5, 0.5], [0.0, 0.5], [0.5, 0.0], [1.0, 0.5], [0.5, 1.0]]
    assert output['point_marker_list'] == [1, 1, 1, 1, 0, 1, 1, 1, 1]
    assert output['triangle_list'] == [7, 2, 4, 5, 0, 4, 4, 8]

def test_point_list_get():
    test = CyTriangle(input_dict=simple_input)
    assert test.in_.point_list == [[0.0, 0.0], [0.0, 1.0], [1.0, 1.0], [1.0, 0.0]]

def test_validate_input_flags():
    test = CyTriangle(input_dict=simple_input)
    with pytest.raises(ValueError):
        test.triangulate('r')
    with pytest.raises(ValueError):
        test.triangulate('p')

def test_memory_deallocation():
    test = CyTriangle(input_dict=simple_input)
    del test  # Deallocate memory without errors
