# HW2 external checker. Usage: julia hw2_checker.jl hw2.jl
# No changes, test flags, or special readline calls are needed in hw2.jl.
# Each case runs in a fresh Julia process. Its standard input is a file containing
# five numbers, one per line, so ordinary readline() calls receive the test data.
# Only Julia standard-library modules are used. Run only code you trust:
# a separate process provides isolation between cases, not a security sandbox.

using Serialization

# This small driver stays inside the checker; it is never added to student code.
# It includes the student's file, records result variables, and preserves errors.
const HW2_DRIVER = raw"""
using Serialization

function hw2_driver(program, record_path)
    problem = nothing
    try
        Base.include(Main, program)
    catch err
        problem = err
    end
    cause = problem
    while cause isa LoadError
        cause = cause.error
    end
    # include() may create new global bindings. Read them in the latest world
    # so this also works with Julia 1.12's world-age rules.
    variables = Base.invokelatest() do
        result = Dict{Symbol,Any}()
        for name in (:height_at_wall, :vertical_state, :clears)
            if isdefined(Main, name)
                result[name] = getproperty(Main, name)
            end
        end
        result
    end
    serialize(record_path, (argument_error=cause isa ArgumentError, variables=variables))
    if problem !== nothing
        showerror(stderr, problem)
        println(stderr)
        return 1
    end
    return 0
end

program, record_path = ARGS
empty!(ARGS)  # The student's program receives no checker-specific arguments.
exit(hw2_driver(program, record_path))
"""

function capture_program(program, values; timeout=15.0)
    mktempdir() do directory
        input_file = joinpath(directory, "input.txt")
        output_file = joinpath(directory, "output.txt")
        error_file = joinpath(directory, "error.txt")
        record_file = joinpath(directory, "record.bin")
        write(input_file, join(string.(values), "\n") * "\n")
        command = `$(Base.julia_cmd()) --startup-file=no --history-file=no -e $HW2_DRIVER $program $record_file`
        command = Cmd(command; dir=dirname(program))
        process = run(
            pipeline(
                ignorestatus(command);
                stdin=input_file,
                stdout=output_file,
                stderr=error_file,
            );
            wait=false,
        )
        timed_out = timedwait(() -> process_exited(process), timeout) == :timed_out
        if timed_out && !process_exited(process)
            kill(process)
        end
        wait(process)
        record = if isfile(record_file)
            deserialize(record_file)
        else
            (argument_error=false, variables=Dict{Symbol,Any}())
        end
        return (
            ok=success(process),
            timed_out=timed_out,
            record=record,
            output=read(output_file, String),
            errors=read(error_file, String),
        )
    end
end

function check_case(program, case)
    result = capture_program(program, case.values)
    expected = if case.height === nothing
        ["Result: " * case.message]
    else
        [
        "Height at wall: $(case.height) m",
        "Vertical motion: $(case.state)",
        "Result: " * case.message,
    ]
    end
    reasons = String[]
    result.timed_out && push!(reasons, "Program did not finish within 15 seconds.")
    prompts = [
        "Launch speed (m/s):",
        "Launch angle (deg):",
        "Wall distance (m):",
        "Wall height (m):",
        "Gravity (m/s^2):",
    ]
    normalized = replace(result.output, "\r\n" => "\n")
    lines = isempty(normalized) ? String[] : split(chomp(normalized), '\n')
    prompt_count = 0
    for i in 1:min(5, length(lines))
        lines[i] == prompts[i] || break
        prompt_count += 1
    end
    result_lines = lines[(prompt_count + 1):end]

    if case.invalid
        # An invalid value may be rejected immediately after it is read.
        if result.ok || !result.record.argument_error
            push!(reasons, "Invalid input must stop with ArgumentError.")
        end
        isempty(result_lines) || push!(reasons, "Invalid input must print no result lines.")
    else
        result.ok || push!(reasons, "Your program stopped with an error.")
        prompt_count == 5 ||
            push!(reasons, "Print the five specified input prompts, one per line.")
        if length(result_lines) != length(expected)
            push!(
                reasons,
                "Expected $(length(expected)) result line(s); found $(length(result_lines)).",
            )
        else
            first_exact = 1
            if case.height !== nothing
                match_height = match(r"^Height at wall: (.+) m$", result_lines[1])
                shown = if match_height === nothing
                    nothing
                else
                    tryparse(Float64, match_height.captures[1])
                end
                if shown === nothing ||
                    !isfinite(shown) ||
                    !isapprox(shown, case.height; atol=1e-4, rtol=0)
                    push!(
                        reasons,
                        "The printed height or its format is incorrect (tolerance: 0.0001 m).",
                    )
                end
                first_exact = 2
            end
            for i in first_exact:length(expected)
                result_lines[i] == expected[i] ||
                    push!(reasons, "Result line $i does not match.")
            end
        end
        height = get(result.record.variables, :height_at_wall, nothing)
        if !(height isa Real) ||
            height isa Bool ||
            !isfinite(height) ||
            !isapprox(height, case.calculated_height; atol=1e-8, rtol=1e-10)
            push!(reasons, "Define height_at_wall using the unrounded calculation.")
        end
        if case.height !== nothing
            get(result.record.variables, :vertical_state, nothing) == case.state ||
                push!(reasons, "The variable vertical_state is missing or incorrect.")
            get(result.record.variables, :clears, nothing) === case.clears ||
                push!(reasons, "The Boolean variable clears is missing or incorrect.")
        end
    end

    passed = isempty(reasons)
    println(passed ? "PASS: " : "FAIL: ", case.name)
    if !passed
        println(
            "  Input (speed, angle, wall distance, wall height, gravity): ", case.values
        )
        for reason in reasons
            println("  - ", reason)
        end
        println("  Expected after the input prompts:")
        if case.invalid
            println("    ArgumentError, with no result lines.")
        else
            for line in expected
                println("    ", line)
            end
        end
        println("  Your complete output:")
        if isempty(lines)
            println("    (no output)")
        else
            for line in lines
                println("    ", line)
            end
        end
        if !isempty(result.errors)
            println("  Error details:")
            for line in Iterators.take(split(chomp(result.errors), '\n'), 8)
                println("    ", line)
            end
        end
    end
    return passed
end

function test_cases()
    cases = NamedTuple[
        (
            name="rising and clears",
            values=(20.0, 45.0, 10.0, 7.0, 9.81),
            height=7.5475,
            calculated_height=7.5475,
            state="rising",
            clears=true,
            message="The projectile clears the wall.",
            invalid=false,
        ),
        (
            name="rising and hits wall",
            values=(20.0, 45.0, 10.0, 8.0, 9.81),
            height=7.5475,
            calculated_height=7.5475,
            state="rising",
            clears=false,
            message="The projectile hits the wall.",
            invalid=false,
        ),
        (
            name="falling and clears",
            values=(20.0, 45.0, 30.0, 7.0, 9.81),
            height=7.9275,
            calculated_height=7.9275,
            state="falling",
            clears=true,
            message="The projectile clears the wall.",
            invalid=false,
        ),
        (
            name="falling and hits wall",
            values=(20.0, 45.0, 30.0, 8.0, 9.81),
            height=7.9275,
            calculated_height=7.9275,
            state="falling",
            clears=false,
            message="The projectile hits the wall.",
            invalid=false,
        ),
        (
            name="lands before wall: one result line only",
            values=(20.0, 45.0, 50.0, 2.0, 9.81),
            height=nothing,
            calculated_height=-11.3125,
            state=nothing,
            clears=nothing,
            message="The projectile lands before the wall.",
            invalid=false,
        ),
        (
            name="exact edge; zero vertical velocity counts as falling",
            values=(20.0, 0.0, 0.0, 0.0, 9.81),
            height=0.0,
            calculated_height=0.0,
            state="falling",
            clears=true,
            message="The projectile hits the edge of the wall.",
            invalid=false,
        ),
    ]
    invalid_cases = [
        ("zero speed", (0.0, 45.0, 10.0, 7.0, 9.81)),
        ("negative speed", (-1.0, 45.0, 10.0, 7.0, 9.81)),
        ("negative angle", (20.0, -1.0, 10.0, 7.0, 9.81)),
        ("90-degree launch", (20.0, 90.0, 10.0, 7.0, 9.81)),
        ("negative wall distance", (20.0, 45.0, -1.0, 7.0, 9.81)),
        ("negative wall height", (20.0, 45.0, 10.0, -1.0, 9.81)),
        ("zero gravity", (20.0, 45.0, 10.0, 7.0, 0.0)),
        ("negative gravity", (20.0, 45.0, 10.0, 7.0, -1.0)),
    ]
    input_names = ("speed", "angle", "wall distance", "wall height", "gravity")
    for i in 1:5, value in (Inf, NaN)
        values = [20.0, 45.0, 10.0, 7.0, 9.81]
        values[i] = value
        push!(invalid_cases, ("$(value) $(input_names[i])", Tuple(values)))
    end
    for (name, values) in invalid_cases
        push!(
            cases,
            (
                name=name,
                values=values,
                height=nothing,
                calculated_height=nothing,
                state=nothing,
                clears=nothing,
                message="",
                invalid=true,
            ),
        )
    end
    return cases
end

function main(args)
    if length(args) != 1
        println(stderr, "Usage: julia hw2_checker.jl path/to/hw2.jl")
        return 2
    end
    program = abspath(args[1])
    if !isfile(program)
        println(stderr, "Student file not found: ", program)
        return 2
    end
    println("Checking: ", program)
    println("Input is supplied automatically to your existing readline() calls.\n")
    cases = test_cases()
    passed = 0
    for case in cases
        passed += check_case(program, case)
    end
    println("\nChecks: $passed/$(length(cases)) passed.")
    return passed == length(cases) ? 0 : 1
end

if abspath(PROGRAM_FILE) == abspath(@__FILE__)
    exit(main(ARGS))
end
