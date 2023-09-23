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
    assert output['triangle_list'] == [[7, 2, 4], [5, 0, 4], [4, 8, 1], [4, 1, 5], [4, 0, 6], [6, 3, 4], [4, 3, 7], [4, 2, 8]]

def test_input_point_list():
    test = CyTriangle(input_dict=simple_input)
    assert test.in_.point_list == [[0.0, 0.0], [0.0, 1.0], [1.0, 1.0], [1.0, 0.0]]

def test_validate_input_flags():
    test = CyTriangle(input_dict=simple_input)
    with pytest.raises(ValueError):
        test.triangulate('r')
    with pytest.raises(ValueError):
        test.triangulate('p')

def test_validate_missing_input_elements():
    with pytest.raises(ValueError):
        test = CyTriangle({**simple_input, 'point_attribute_list': [[1], [1], [1]]})
    with pytest.raises(ValueError):
        additional_input = {**simple_input, 'triangle_list': [[0, 1, 2], [2, 3, 0]], 'triangle_attribute_list': [[2, 3]]}
        test = CyTriangle(additional_input)

def test_input_optional_point_fields():
    additional_input = {**simple_input, 'point_attribute_list': [[0, 1], [2, 3], [4, 5], [6, 7]], 'point_marker_list': [1, 2, 3, 4]}
    test = CyTriangle(additional_input)
    assert test.in_.point_attribute_list == [[0, 1], [2, 3], [4, 5], [6, 7]]
    assert test.in_.point_marker_list == [1, 2, 3, 4]

def test_input_optional_triangle_fields():
    additional_input = {**simple_input, 'triangle_list': [[0, 1, 2], [2, 3, 0]], 'triangle_attribute_list': [[0, 1], [2, 3]]}
    test = CyTriangle(additional_input)
    assert test.in_.triangle_attribute_list == [[0, 1], [2, 3]]

def test_input_output_neighbor_field():
    test = CyTriangle(input_dict=simple_input)
    test.triangulate('na0.2')
    output = test.get_output_as_dict()
    assert output['neighbor_list'] == [[7, 6], [4, 3], [3, 7], [1, 2], [5, 1], [6, 4], [0, 5], [2, 0]]

def test_input_segment_fields():
    test = CyTriangle(input_dict={**simple_input, 'segment_list': [[0, 1], [1, 2]], 'segment_marker_list': [0, 1]})
    assert test.in_.segment_list == [[0, 1], [1, 2]]
    assert test.in_.segment_marker_list == [0, 1]

def test_input_hole_field():
    test = CyTriangle(input_dict={**simple_input, 'hole_list': [[0.5, 0.5]]})
    assert test.in_.hole_list == [[0.5, 0.5]]

def test_input_region_field():
    test = CyTriangle(input_dict={**simple_input, 'region_list': [{'point': [0.5, 0.5], 'max_area': 0.2, 'marker': 1}]})
    assert test.in_.region_list == [{'point': [0.5, 0.5], 'max_area': 0.2, 'marker': 1}]

def test_memory_deallocation():
    test = CyTriangle(input_dict=simple_input)
    del test  # Deallocate memory without errors
