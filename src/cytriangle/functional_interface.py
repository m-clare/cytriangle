from cytriangle.cytriangle import CyTriangle


def triangulate(input_dict, flags):
    """
    Triangulates an input dict with the following properties:

    Required entries:
    - vertices: A list of pairs [x, y] that are vertex coordinates.

    Optional entries:
    - vertex_attributes: An list of lists of vertex attributes (floats).
      Each vertex must have the same number of attributes, and
      len(vertex_attributes) must match the number of points.

    - vertex_markers: A list of vertex markers; one int per point.

    - triangles: A list of lists of triangle corners (not necessarily 3).
      Corners are designated in a counterclockwise order, followed by any
      other nodes if the triangle represents a nonlinear element (e.g. num_corners > 3).

    - triangle_attributes: A list of triangle attributes. Each triangle must have
      the same number of attributes.

    - triangle_max_area: A list of triangle area constraints; one per triangle,
      0 if not set.

    - segments: A list of segment endpoints, where each list contains vertex
      indices.

    - segment_markers: A list of segment markers; one int per segment.

    - holes: A list of [x, y] hole coordinates.

    - regions: A list of regional attributes and area constraints. Note that
      each regional attribute is used only if you select the `A` switch, and each area
      constraint is used only if you select the `a` switch (with no number following).

    Returns:
    - A dictionary containing the successful triangulation data.

    """
    # parse regions
    if "regions" in input_dict:
        raw_regions = input_dict["regions"]
        parsed_regions = []
        for region in raw_regions:
            parsed_regions.append(
                {
                    "vertex": [region[0], region[1]],
                    "marker": int(region[2]),
                    "max_area": region[3],
                }
            )
        input_dict["regions"] = parsed_regions
    triangle_obj = CyTriangle(input_dict)
    triangle_obj.triangulate(flags)
    return triangle_obj.out.to_dict(opt="np")
