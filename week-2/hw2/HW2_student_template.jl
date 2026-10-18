# Homework 2 — Projectile and wall
# Save your completed program as YOUR_ID.jl.
# Run with keyboard input: julia YOUR_ID.jl
# Run the separate checker: julia hw2_checker.jl YOUR_ID.jl
# Submit only your completed program, not hw2_checker.jl.
# No test code, special command-line handling, functions, or loops are needed here.

# INPUT: read five numbers, one per line, in this order.
println("Launch speed (m/s):")
speed_m_s = parse(Float64, readline())

# Complete the remaining inputs with these variable names and prompts:
# angle_deg        "Launch angle (deg):"
# wall_x_m         "Wall distance (m):"
# wall_height_m    "Wall height (m):"
# gravity_m_s2     "Gravity (m/s^2):"
# Print each prompt with println, then read and parse the number.

# PROCESSING AND OUTPUT:
# Check finiteness and the physical ranges in the assignment before calculating.
# Invalid input must throw ArgumentError without printing result lines.
# Calculate height_at_wall for every valid input.
# If it is negative, print only:
#   Result: The projectile lands before the wall.
# Otherwise, calculate vertical_state and the Boolean clears, and use nested
# conditionals to print exactly three result lines as specified in the assignment.
# Use the unrounded height for comparisons. An exact edge hit gives clears = true.

error("Replace this line with your solution")
