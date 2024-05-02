from cytriangle.cytriangle import CyTriangle


def triangulate(input_dict, flags):
    # parse regions
    raw_regions = input_dict["regions"]
    parsed_regions = []
    for region in raw_regions:
        parsed_regions.append(
            {
                "vertex": [region[0], region[1]],
                "marker": region[2],
                "max_area": region[3],
            }
        )
    input_dict["regions"] = parsed_regions
    input = CyTriangle(input_dict)
    input.triangulate(triswitches=flags)
    return input.out.to_dict()
