from cytriangle.cytriangle import CyTriangle


def triangulate(input_dict, flags):
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
    return triangle_obj.out.to_dict(opt='np')