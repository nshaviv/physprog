# Homework 2 — Projectile and wall
# Save a copy as YOUR_ID.jl, replacing YOUR_ID with your student ID.
# Complete the INPUT section, then write your solution between the markers.
# The program will stop with an error until you replace the error line below.
# To run: open a terminal in the file's directory and enter julia YOUR_ID.jl.
# Enter one number per line when prompted.
# No function definitions or loops are needed.

# ------------------------------------------------------------
# INPUT — read five numbers from the keyboard
#
# The first input is complete. Add the other four in the same form.
# Before reading each number, use println to print the corresponding prompt:
#   "Launch angle (deg):"
#   "Wall distance (m):"
#   "Wall height (m):"
#   "Gravity (m/s^2):"
#
# Keep this order: launch speed, angle, wall distance, wall height, gravity.
# ------------------------------------------------------------

println("Launch speed (m/s):")
speed_m_s = parse(Float64, readline())

# TODO: read values into the following variables:
# angle_deg, wall_x_m, wall_height_m, gravity_m_s2

# === BEGIN STUDENT CODE ===
# Write your solution here:
#
# 1. Check that all five inputs are finite and satisfy the required ranges:
#      speed_m_s > 0
#      0 <= angle_deg < 90
#      wall_x_m >= 0
#      wall_height_m >= 0
#      gravity_m_s2 > 0
#    Validate before computing the arrival time, height, or vertical velocity.
#    Also check that the horizontal velocity is positive before dividing.
#    For invalid input, stop the program with:
#      throw(ArgumentError("your message"))
#    Choose a message describing the problem. Do not print result lines.
#
#    Inputs are read with parse(Float64, ...), so they are already Float64.
#    Check isfinite and the ranges above; no additional type checks are needed.
#
# 2. For every valid input, compute:
#    height_at_wall — free-flight height at the wall plane, in meters.
#
#    Use an outer conditional to distinguish these cases:
#    If height_at_wall < 0, print only:
#      Result: The projectile lands before the wall.
#    Do not print the height or vertical motion in this case.
#    You do not need to define vertical_state or clears in this branch.
#
#    Otherwise, compute the vertical velocity and define:
#    vertical_state — "rising" if the vertical velocity is positive,
#                     otherwise "falling", including zero vertical velocity.
#    clears — a Boolean indicating whether the height reaches the wall's top:
#      true when height_at_wall >= wall_height_m, otherwise false.
#    An exact hit on the top edge also gives true.
#
#    Use sind/cosd, or convert the angle to radians with deg2rad.
#    Use the unrounded height for all comparisons, even if you round the output.
#
# 3. In the nonnegative-height branch only, print exactly three result lines:
#      Height at wall: <number> m
#      Vertical motion: <state>
#      Result: <result>
#
#    Replace <number> with the calculated height and <state> with rising or falling.
#    Replace <result> with exactly one of these three messages:
#      The projectile hits the wall.
#      The projectile hits the edge of the wall.
#      The projectile clears the wall.
#
#    Use nested conditionals in this branch to determine the vertical state
#    and classify the wall interaction. Keep the height and vertical-motion
#    output inside this branch.
#    Print only the input prompts and the required result lines:
#    one result line for landing before the wall, three otherwise.
#    Do not print headings or debug output.

error("Replace this line with your solution")

# === END STUDENT CODE ===
