# Bug1 Algorithm Implementation in MATLAB

## Overview
This MATLAB code implements the Bug1 algorithm for robotic path planning, enabling a robot to navigate from a start point to a goal while avoiding polygonal obstacles. The algorithm alternates between two modes: moving toward the goal and circumventing obstacles upon collision. It is designed to handle non-convex obstacles and includes visualization tools for debugging.

## Features
- **Obstacle Handling**: Supports non-convex polygonal obstacles defined by vertices.
- **Real-time Visualization**: Displays the robot's path, obstacles, start/goal points, and current state.
- **Debug Mode**: Provides step-by-step console logs for tracking collision events and state transitions.
- **Adaptive Parameters**: Adjustable step size, goal tolerance, and obstacle complexity for testing.

## Dependencies
- **MATLAB R2016b or later** (tested on MATLAB 2021a).
- Required Toolboxes: None (core MATLAB functions only).

## Usage
1. **Define Parameters**:
   - `start_point`, `goal_point`: Initial and target positions.
   - `step_size`: Movement precision (smaller values increase path smoothness).
   - `tolerance`: Threshold to determine if the goal is reached.
   - `obstaclelist`: Cell array of obstacles, each defined by clockwise-ordered vertices forming a closed polygon.

2. **Run the Script**:
   - Execute the script in MATLAB. A figure window will show real-time updates of the robot's path and obstacles.

3. **Debug Mode**:
   - Set `debug_mode = true` to view collision points, obstacle circumvention status, and step counts in the console.

## Key Functions
- `checkCollision_pro`: Checks if a movement step collides with any obstacle.
- `followBoundary`: Guides the robot along the obstacle boundary.
- `calClosetPoint`: Finds the closest point on the obstacle boundary to the goal.
- `rotationWithPoint`: Handles vertex turning during boundary following.

## Parameters Explanation
- **Step Size**: Smaller values (e.g., `0.05`) improve path precision but may increase computation time.
- **Tolerance**: Determines how close the robot must be to the goal to terminate (default: `0.2`).
- **Obstacles**: Ensure polygons are closed (first and last points identical) and ordered clockwise.

## Example Output
- The robot (blue dot) moves from the green start to the magenta goal, avoiding red obstacles.
- Console logs in debug mode report collisions, obstacle circumnavigation, and completion steps.

## Notes
- **Infinite Loop Prevention**: The code includes random directional perturbations to avoid deadlocks.
- **Obstacle Complexity**: Highly concave obstacles may require tuning `step_size` or `tolerance`.
- **Visualization**: The path updates dynamically, and the title reflects the current state (`moving_to_goal` or `circumvent_obstacle`).

## License
Open-source under the MIT License. Modify and distribute freely. Attribution is appreciated but not required.
