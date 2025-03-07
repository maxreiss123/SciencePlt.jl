include("../src/SciencePlt.jl")

using .SciencePlt
using Plots
using LaTeXStrings

# Model function (similar to SciencePlots Python examples)
function model(x, p)
    return x .^ (2 * p + 1) ./ (1 .+ x .^ (2 * p))
end

# Create a directory for figures
isdir("figures") || mkdir("figures")

# Example 1: Basic science style
function example_science()
    println("Available styles: ", join(list_styles(), ", "))
    println("Testing science style...")
    
    x = LinRange(0.75, 1.25, 201)
    p_values = [10, 15, 20, 30, 50, 100]
    
    # Use the science style
    use_style("science")
    
    # Create a plot
    plt = plot(
        title = "",
        xlabel = L"Voltage (mV)",
        ylabel = L"Current ($\mu$A)",
        legend = :bottomright,
        legendtitle = "Order"
    )
    
    # Add lines for each p value
    for p in p_values
        plot!(plt, x, model(x, p), label = "$p")
    end
    
    # Save the plot
    savefig(plt, "figures/fig01_science.pdf")
    println("Science style plot generated successfully.")
    
    return plt
end

# Example 2: IEEE style
function example_ieee()
    println("Testing science+ieee style...")
    
    x = LinRange(0.75, 1.25, 201)
    p_values = [10, 20, 40, 100]
    linestyles = [:solid, :dash, :dot, :dashdot]
    
    # Use the IEEE style
    use_style("science+ieee")
    
    # Create a plot
    plt = plot(
        title = "",
        xlabel = L"Voltage (mV)",
        ylabel = L"Current ($\mu$A)",
        legend = :bottomright,
        legendtitle = "Order"
    )
    
    # Add lines for each p value with specific line styles
    for (i, p) in enumerate(p_values)
        plot!(plt, x, model(x, p), label = "$p", linestyle = linestyles[i])
    end
    
    # Save the plot
    savefig(plt, "figures/fig02_ieee.pdf")
    println("IEEE style plot generated successfully.")
    
    return plt
end

# Example 3: Vibrant colors style
function example_vibrant()
    println("Testing science+vibrant style...")
    
    x = LinRange(0.75, 1.25, 201)
    p_values = [5, 10, 15, 20, 30, 50, 100]
    
    # Use the vibrant style
    use_style("science+vibrant")
    
    # Create a plot
    plt = plot(
        title = "",
        xlabel = L"Voltage (mV)",
        ylabel = L"Current ($\mu$A)",
        legend = :bottomright,
        legendtitle = "Order"
    )
    
    # Add lines for each p value
    for p in p_values
        plot!(plt, x, model(x, p), label = "$p")
    end
    
    # Save the plot
    savefig(plt, "figures/fig03_vibrant.pdf")
    println("Vibrant style plot generated successfully.")
    
    return plt
end

# Main execution
function run_examples()
    println("Running SciencePlots.jl examples...")
    example_science()
    example_ieee()
    example_vibrant()
    println("All examples completed!")
end

run_examples()
