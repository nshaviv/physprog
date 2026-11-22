# Week 7 main homework: submit these three completed functions (Parts A-C).
# Keep your calls and printing in a separate local test file.
using LinearAlgebra

function circulant(v)
    # Return (matrix=C, row_sums=...).
    error("Complete Part A")
end

function matrix_polynomial(A, c)
    # Use a matrix accumulator and Horner's recurrence.
    # Return (matrix=P, diagonal_sum=...).
    error("Complete Part B")
end

function fit_matrix_polynomial(A, B)
    # Assume square matching inputs, n>=3, with I, A, A*A independent.
    # Each entry of B contributes one equation for three coefficients.
    # Build three design columns with vec, then solve using backslash.
    # Reconstruct the matrix, subtract from B, and calculate RMS per entry.
    # Return (coefficients=..., matrix=..., residuals=..., rms=...).
    error("Complete Part C")
end
