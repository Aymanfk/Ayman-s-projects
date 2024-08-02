import json

def map_half_mile_markers(trail_json, trail_length):
    # Load the trail coordinates from JSON
    with open(trail_json, 'r') as f:
        data = json.load(f)
    
    # Access the list of coordinates
    #print(data)
    try:
        coordinates = data['data']['trackData'][0]
    except:
        coordinates = data['features'][0]['geometry']['coordinates'][0]
        print(coordinates)

    num_points = len(coordinates)
    print(num_points)
    marker_step = trail_length / (num_points - 1)  # Distance between each point
    
    # Prepare the result as a list of dictionaries
    half_mile_markers = []
    
    current_marker_distance = 0.0
    while current_marker_distance <= trail_length:
        # Determine the closest point index
        closest_point_index = int(round(current_marker_distance / marker_step))
        # Ensure the index is within the bounds of the coordinates list
        closest_point_index = min(closest_point_index, num_points - 1)
        
        # Get the closest coordinate point
        closest_coordinate = coordinates[closest_point_index]
        
        # Append the marker and its closest coordinate (lon, lat) to the result
        half_mile_markers.append({
            "Mile": current_marker_distance,
            "Long": closest_coordinate['lon'],
            "Lat": closest_coordinate['lat']
        })
        
        # Move to the next half mile
        current_marker_distance += 0.5
    
    # Write the result to a new JSON file
    with open('Documents/JMB_mile_markers.json', 'w') as f:
        json.dump(half_mile_markers, f, indent=4)
    
    print("Half-mile markers mapped and saved to 'half_mile_markers.json'.")

map_half_mile_markers('Downloads/Tour du Mont Blanc (TMB).json', 102)