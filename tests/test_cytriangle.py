import pytest
from cytriangle.cytriangle import CyTriangle

simple_input = {"vertices": [[0, 0], [0, 1], [1, 1], [1, 0]]}

tricall_input = {
    "vertices": [[0, 0], [1, 0], [1, 10], [10, 0]],
    "vertex_attributes": [[0], [1], [11], [10]],
    "vertex_markers": [0, 2, 0, 0],
    "regions": [{"vertex": [0.5, 5.0], "marker": 7, "max_area": 0.1}],
}


def test_simple_triangle_point_input():
    test = CyTriangle(input_dict=simple_input)
    assert test.get_input_as_dict() == {
        "vertices": [[0.0, 0.0], [0.0, 1.0], [1.0, 1.0], [1.0, 0.0]]
    }


def test_simple_triangle_area():
    test = CyTriangle(input_dict=simple_input)
    test.triangulate("a0.2")
    output = test.get_output_as_dict()
    assert output["vertices"] == [
        [0.0, 0.0],
        [0.0, 1.0],
        [1.0, 1.0],
        [1.0, 0.0],
        [0.5, 0.5],
        [0.0, 0.5],
        [0.5, 0.0],
        [1.0, 0.5],
        [0.5, 1.0],
    ]
    assert output["vertex_markers"] == [1, 1, 1, 1, 0, 1, 1, 1, 1]
    assert output["triangles"] == [
        [7, 2, 4],
        [5, 0, 4],
        [4, 8, 1],
        [4, 1, 5],
        [4, 0, 6],
        [6, 3, 4],
        [4, 3, 7],
        [4, 2, 8],
    ]


def test_input_vertices():
    test = CyTriangle(input_dict=simple_input)
    assert test.in_.vertices == [[0.0, 0.0], [0.0, 1.0], [1.0, 1.0], [1.0, 0.0]]


def test_validate_missing_input_elements():
    with pytest.raises(ValueError):
        test = CyTriangle({**simple_input, "vertex_attributes": [[1], [1], [1]]})
    with pytest.raises(ValueError):
        additional_input = {
            **simple_input,
            "triangles": [[0, 1, 2], [2, 3, 0]],
            "triangle_attributes": [[2, 3]],
        }
        test = CyTriangle(additional_input)


def test_input_optional_point_fields():
    additional_input = {
        **simple_input,
        "vertex_attributes": [[0, 1], [2, 3], [4, 5], [6, 7]],
        "vertex_markers": [1, 2, 3, 4],
    }
    test = CyTriangle(additional_input)
    assert test.in_.vertex_attributes == [[0, 1], [2, 3], [4, 5], [6, 7]]
    assert test.in_.vertex_markers == [1, 2, 3, 4]


def test_input_optional_triangle_fields():
    additional_input = {
        **simple_input,
        "triangles": [[0, 1, 2], [2, 3, 0]],
        "triangle_attributes": [[0, 1], [2, 3]],
    }
    test = CyTriangle(additional_input)
    assert test.in_.triangle_attributes == [[0, 1], [2, 3]]


def test_input_output_neighbor_field():
    test = CyTriangle(input_dict=simple_input)
    test.triangulate("na0.2")
    assert test.out.neighbors == [
        [7, 6],
        [4, 3],
        [3, 7],
        [1, 2],
        [5, 1],
        [6, 4],
        [0, 5],
        [2, 0],
    ]


def test_input_segment_fields():
    test = CyTriangle(
        input_dict={
            **simple_input,
            "segments": [[0, 1], [1, 2]],
            "segment_markers": [0, 1],
        }
    )
    assert test.in_.segments == [[0, 1], [1, 2]]
    assert test.in_.segment_markers == [0, 1]


def test_input_hole_field():
    test = CyTriangle(input_dict={**simple_input, "holes": [[0.5, 0.5]]})
    assert test.in_.holes == [[0.5, 0.5]]


def test_input_region_field():
    test = CyTriangle(
        input_dict={
            **simple_input,
            "regions": [{"vertex": [0.5, 0.5], "max_area": 0.2, "marker": 1}],
        }
    )
    assert test.in_.regions == [{"vertex": [0.5, 0.5], "max_area": 0.2, "marker": 1}]


def test_output_edge_fields():
    test = CyTriangle(input_dict=tricall_input)
    test.triangulate("czAevn")
    assert test.out.edges == [[0, 1], [1, 2], [2, 0], [3, 2], [1, 3]]


def test_refine_output_fields():
    test = CyTriangle(input_dict=tricall_input)
    test.triangulate("czAevn")
    refine_output = test.get_output_as_dict()
    test_refine = CyTriangle(refine_output)
    test_refine.in_.set_triangle_areas([3.0, 1.0])
    test_refine.triangulate("prazBP")
    assert test_refine.out.triangles == [
        [26, 10, 13],
        [24, 4, 9],
        [18, 8, 15],
        [11, 14, 1],
        [14, 5, 9],
        [14, 9, 7],
        [4, 7, 9],
        [4, 0, 7],
        [0, 1, 7],
        [24, 9, 5],
        [12, 16, 17],
        [6, 16, 11],
        [14, 11, 16],
        [1, 14, 7],
        [12, 5, 14],
        [15, 24, 5],
        [6, 17, 16],
        [24, 26, 13],
        [19, 12, 17],
        [2, 10, 25],
        [23, 22, 17],
        [14, 16, 12],
        [12, 19, 18],
        [18, 19, 8],
        [8, 20, 15],
        [5, 12, 18],
        [23, 17, 21],
        [22, 19, 17],
        [26, 25, 10],
        [26, 15, 20],
        [21, 3, 23],
        [22, 8, 19],
        [21, 17, 6],
        [4, 24, 13],
        [5, 18, 15],
        [20, 2, 25],
        [15, 26, 24],
        [25, 26, 20],
    ]


def test_memory_deallocation():
    test = CyTriangle(input_dict=simple_input)
    del test  # Deallocate memory without errors
