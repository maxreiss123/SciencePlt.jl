module SciencePlt

using Plots
using Colors
using ColorSchemes
using LaTeXStrings

export science_theme, apply_theme
export use_style, with_style
export list_styles, list_categories

# Helper function to convert hex to color
hex_to_color(hex) = parse(Colorant, hex)

# Global variable to store styles
const STYLES = Dict{String, Dict{Symbol, Any}}()

# Style categories
const STYLE_CATEGORIES = [
    "science",       # Base scientific style
    "journals",      # Journal-specific styles
    "color",         # Color schemes
    "languages",     # Language support
    "misc"           # Miscellaneous style settings
]

"""
    list_categories()

List all available style categories.
"""
list_categories() = STYLE_CATEGORIES

"""
    list_styles([category])

List all available styles, optionally filtered by category.
"""
function list_styles(category=nothing)
    if isnothing(category)
        return sort(collect(keys(STYLES)))
    else
        return sort([style for (style, props) in STYLES if props[:category] == category])
    end
end

"""
    use_style(style::String)

Apply a plot style globally for all future plots.
"""
function use_style(style::String)
    if !haskey(STYLES, style)
        error("Style '$style' not found. Available styles: $(join(list_styles(), ", "))")
    end
    
    # Get the theme dictionary
    theme_dict = STYLES[style][:theme]
    
    # Apply the core attributes directly
    Plots.default(; theme_dict...)
    
    return nothing
end

"""
    with_style(f::Function, style::String)

Apply a style temporarily for the duration of function `f`.
"""
function with_style(f::Function, style::String)
    if !haskey(STYLES, style)
        error("Style '$style' not found. Available styles: $(join(list_styles(), ", "))")
    end
    
    # Save current settings
    old_settings = Plots.default()
    
    try
        # Apply new style
        use_style(style)
        # Execute function
        return f()
    finally
        # Restore old settings
        Plots.default(; old_settings...)
    end
end

"""
    apply_theme(p, style::String)

Apply a style to an existing plot object.
"""
function apply_theme(p, style::String)
    if !haskey(STYLES, style)
        error("Style '$style' not found. Available styles: $(join(list_styles(), ", "))")
    end
    
    # Get theme dictionary
    theme_dict = STYLES[style][:theme]
    
    # Apply each setting to the plot
    plot!(p; theme_dict...)
    
    return p
end

"""
    science_theme()

Create a dictionary with the default science theme settings.
"""
function science_theme()
    return Dict(
        # Figure size
        :size => (350, 262), # in pixels, roughly 3.5 x 2.625 inches @ 100 dpi
        
        # Colors based on 'std-colors' scheme
        :palette => [
            hex_to_color("#0C5DA5"), # blue
            hex_to_color("#00B945"), # green
            hex_to_color("#FF9500"), # yellow
            hex_to_color("#FF2C00"), # red
            hex_to_color("#845B97"), # violet
            hex_to_color("#474747"), # dark gray
            hex_to_color("#9e9e9e")  # light gray
        ],
        
        # Axis styling
        :framestyle => :box,
        :grid => false,
        :minorticks => true,
        :tickdirection => :in,
        :guidefontsize => 10,
        :tickfontsize => 8,
        :legendfontsize => 8,
        
        # Line properties
        :linewidth => 1.0,
        
        # Font settings
        :fontfamily => "serif",
        
        # LaTeX settings
        :plot_titlefontfamily => "serif",
        :title => false
    )
end

"""
    register_base_styles()

Register the base scientific style.
"""
function register_base_styles()
    # Register the base 'science' style
    STYLES["science"] = Dict(
        :category => "science",
        :description => "Base scientific style for publication-quality plots",
        :theme => science_theme()
    )
end

"""
    register_color_styles()

Register color schemes from Paul Tol's website.
"""
function register_color_styles()
    # Standard color schemes from Paul Tol's website
    
    # Bright color scheme
    STYLES["bright"] = Dict(
        :category => "color",
        :description => "Bright color scheme (color-blind safe)",
        :theme => Dict(
            :palette => [
                hex_to_color("#4477AA"), 
                hex_to_color("#EE6677"), 
                hex_to_color("#228833"), 
                hex_to_color("#CCBB44"), 
                hex_to_color("#66CCEE"), 
                hex_to_color("#AA3377"), 
                hex_to_color("#BBBBBB")
            ]
        )
    )
    
    # Vibrant color scheme
    STYLES["vibrant"] = Dict(
        :category => "color",
        :description => "Vibrant color scheme (color-blind safe)",
        :theme => Dict(
            :palette => [
                hex_to_color("#EE7733"), 
                hex_to_color("#0077BB"), 
                hex_to_color("#33BBEE"), 
                hex_to_color("#EE3377"), 
                hex_to_color("#CC3311"), 
                hex_to_color("#009988"), 
                hex_to_color("#BBBBBB")
            ]
        )
    )
    
    # Muted color scheme
    STYLES["muted"] = Dict(
        :category => "color",
        :description => "Muted color scheme (color-blind safe)",
        :theme => Dict(
            :palette => [
                hex_to_color("#CC6677"), 
                hex_to_color("#332288"), 
                hex_to_color("#DDCC77"), 
                hex_to_color("#117733"), 
                hex_to_color("#88CCEE"), 
                hex_to_color("#882255"), 
                hex_to_color("#44AA99"), 
                hex_to_color("#999933"), 
                hex_to_color("#AA4499"), 
                hex_to_color("#DDDDDD")
            ]
        )
    )
    
    # Light color scheme
    STYLES["light"] = Dict(
        :category => "color",
        :description => "Light color scheme (color-blind safe)",
        :theme => Dict(
            :palette => [
                hex_to_color("#77AADD"), 
                hex_to_color("#EE8866"), 
                hex_to_color("#EEDD88"), 
                hex_to_color("#FFAABB"), 
                hex_to_color("#99DDFF"), 
                hex_to_color("#44BB99"), 
                hex_to_color("#BBCC33"), 
                hex_to_color("#AAAA00"), 
                hex_to_color("#DDDDDD")
            ]
        )
    )
    
    # High-contrast color scheme
    STYLES["high-contrast"] = Dict(
        :category => "color",
        :description => "High-contrast color scheme (color-blind safe)",
        :theme => Dict(
            :palette => [
                hex_to_color("#004488"), 
                hex_to_color("#DDAA33"), 
                hex_to_color("#BB5566")
            ]
        )
    )
    
    # Retro color scheme
    STYLES["retro"] = Dict(
        :category => "color",
        :description => "Retro color scheme",
        :theme => Dict(
            :palette => [
                hex_to_color("#4165c0"), 
                hex_to_color("#e770a2"), 
                hex_to_color("#5ac3be"), 
                hex_to_color("#696969"), 
                hex_to_color("#f79a1e"), 
                hex_to_color("#ba7dcd")
            ]
        )
    )
    
    # High-vis color scheme
    STYLES["high-vis"] = Dict(
        :category => "color",
        :description => "High visibility color scheme",
        :theme => Dict(
            :palette => [
                hex_to_color("#0d49fb"), 
                hex_to_color("#e6091c"), 
                hex_to_color("#26eb47"), 
                hex_to_color("#8936df"), 
                hex_to_color("#fec32d"), 
                hex_to_color("#25d7fd")
            ],
            :linestyle => [:solid, :dash, :dashdot, :dot, :solid, :dash]
        )
    )
    
    # Register discrete rainbow color schemes (1-23 colors)
    for n in 1:23
        STYLES["discrete-rainbow-$n"] = Dict(
            :category => "color",
            :description => "Discrete rainbow color scheme with $n colors",
            :theme => Dict(
                :palette => rainbow_colors(n)
            )
        )
    end
    
    # Scatter style
    STYLES["scatter"] = Dict(
        :category => "color",
        :description => "Style for scatter plots",
        :theme => Dict(
            :markershape => [:circle, :rect, :utriangle, :dtriangle, :ltriangle, :rtriangle, :diamond],
            :markersize => 3,
            :palette => [
                hex_to_color("#0C5DA5"), # blue
                hex_to_color("#00B945"), # green
                hex_to_color("#FF9500"), # yellow
                hex_to_color("#FF2C00"), # red
                hex_to_color("#845B97"), # violet
                hex_to_color("#474747"), # dark gray
                hex_to_color("#9e9e9e")  # light gray
            ],
            :linestyle => :none
        )
    )
end

"""
    rainbow_colors(n::Int)

Generate a color palette with n colors from Paul Tol's discrete rainbow.
"""
function rainbow_colors(n::Int)
    # Full rainbow palette from Paul Tol
    full_palette = [
        "#E8ECFB", "#D9CCE3", "#CAACCB", "#BA8DB4", "#AA6F9E", "#994F88", "#882E72",
        "#1965B0", "#437DBF", "#6195CF", "#7BAFDE", "#4EB265", "#90C987", "#CAE0AB",
        "#F7F056", "#F7CB45", "#F4A736", "#EE8026", "#E65518", "#DC050C", "#A5170E",
        "#72190E", "#42150A"
    ]
    
    # Select subset based on predefined combinations
    if n == 1
        return [hex_to_color("#1965B0")]
    elseif n == 2
        return [hex_to_color("#1965B0"), hex_to_color("#DC050C")]
    elseif n == 3
        return [hex_to_color("#1965B0"), hex_to_color("#F7F056"), hex_to_color("#DC050C")]
    elseif n == 4
        return [hex_to_color("#1965B0"), hex_to_color("#4EB265"), hex_to_color("#F7F056"), hex_to_color("#DC050C")]
    elseif n == 5
        return [hex_to_color("#1965B0"), hex_to_color("#7BAFDE"), hex_to_color("#4EB265"), hex_to_color("#F7F056"), hex_to_color("#DC050C")]
    elseif n <= 23
        # For larger palettes, use the specified colors from full palette
        # This is a simplified approach; the actual mappings are in the .mplstyle files
        indices = round.(Int, range(1, length(full_palette), length=n))
        return [hex_to_color(full_palette[i]) for i in indices]
    else
        # Fall back to a color generator for larger values
        return distinguishable_colors(n, [hex_to_color("#1965B0"), hex_to_color("#DC050C")])
    end
end

"""
    register_journal_styles()

Register journal-specific plot styles.
"""
function register_journal_styles()
    # IEEE style
    STYLES["ieee"] = Dict(
        :category => "journals",
        :description => "IEEE journal style",
        :theme => Dict(
            :size => (330, 250), # 3.3 x 2.5 inches
            :dpi => 600,
            :palette => [
                hex_to_color("#000000"), # black
                hex_to_color("#FF0000"), # red
                hex_to_color("#0000FF"), # blue
                hex_to_color("#00FF00")  # green
            ]
            # linestyle will be applied individually to plots, not globally
        )
    )
    
    # Nature style
    STYLES["nature"] = Dict(
        :category => "journals",
        :description => "Nature journal style",
        :theme => Dict(
            :size => (330, 250), # 3.3 x 2.5 inches
            :fontfamily => "sans-serif",
            :fontsize => 7,
            :guidefontsize => 7,
            :tickfontsize => 7,
            :legendfontsize => 7,
            :titlefontsize => 7,
            :linewidth => 1.0,
            :framestyle => :box
        )
    )
end

"""
    register_misc_styles()

Register miscellaneous plot styles.
"""
function register_misc_styles()
    # Grid style
    STYLES["grid"] = Dict(
        :category => "misc",
        :description => "Grid lines and legend frame",
        :theme => Dict(
            :grid => true,
            :gridstyle => :dash,
            :gridcolor => :black,
            :gridalpha => 0.5,
            :gridlinewidth => 0.5,
            :legend_frame => true
        )
    )
    
    # Notebook style (larger figures for notebooks)
    STYLES["notebook"] = Dict(
        :category => "misc",
        :description => "Style for Jupyter notebooks",
        :theme => Dict(
            :size => (800, 600),
            :tickfontsize => 16,
            :guidefontsize => 16,
            :legendfontsize => 16,
            :titlefontsize => 16,
            :linewidth => 2.0,
            :framestyle => :box,
            :fontfamily => "sans-serif"
        )
    )
    
    # No-LaTeX style
    STYLES["no-latex"] = Dict(
        :category => "misc",
        :description => "Style without LaTeX rendering",
        :theme => Dict(
            :fontfamily => "serif"
        )
    )
    
    # Sans-serif style
    STYLES["sans"] = Dict(
        :category => "misc",
        :description => "Style with sans-serif fonts",
        :theme => Dict(
            :fontfamily => "sans-serif"
        )
    )
end

"""
    register_language_styles()

Register language-specific font styles.
"""
function register_language_styles()
    # CJK fonts for Traditional Chinese
    STYLES["cjk-tc-font"] = Dict(
        :category => "languages",
        :description => "Font support for Traditional Chinese",
        :theme => Dict(
            :fontfamily => "Noto Serif CJK TC"
        )
    )
    
    # CJK fonts for Simplified Chinese
    STYLES["cjk-sc-font"] = Dict(
        :category => "languages",
        :description => "Font support for Simplified Chinese",
        :theme => Dict(
            :fontfamily => "Noto Serif CJK SC"
        )
    )
    
    # CJK fonts for Japanese
    STYLES["cjk-jp-font"] = Dict(
        :category => "languages",
        :description => "Font support for Japanese",
        :theme => Dict(
            :fontfamily => "Noto Serif CJK JP"
        )
    )
    
    # CJK fonts for Korean
    STYLES["cjk-kr-font"] = Dict(
        :category => "languages",
        :description => "Font support for Korean",
        :theme => Dict(
            :fontfamily => "Noto Serif CJK KR"
        )
    )
    
    # Russian fonts
    STYLES["russian-font"] = Dict(
        :category => "languages",
        :description => "Font support for Russian",
        :theme => Dict(
            :fontfamily => "serif"
        )
    )
    
    # Turkish fonts
    STYLES["turkish-font"] = Dict(
        :category => "languages",
        :description => "Font support for Turkish",
        :theme => Dict(
            :fontfamily => "serif"
        )
    )
end

"""
    register_combination_styles()

Register combined styles (e.g., science+ieee).
"""
function register_combination_styles()
    # Science + IEEE
    STYLES["science+ieee"] = Dict(
        :category => "combinations",
        :description => "Science style with IEEE specifics",
        :theme => merge(copy(STYLES["science"][:theme]), copy(STYLES["ieee"][:theme]))
    )
    
    # Science + Nature
    STYLES["science+nature"] = Dict(
        :category => "combinations",
        :description => "Science style with Nature journal specifics",
        :theme => merge(copy(STYLES["science"][:theme]), copy(STYLES["nature"][:theme]))
    )
    
    # Science + Grid
    STYLES["science+grid"] = Dict(
        :category => "combinations",
        :description => "Science style with grid lines",
        :theme => merge(copy(STYLES["science"][:theme]), copy(STYLES["grid"][:theme]))
    )
    
    # Combinations with color schemes
    for color_style in ["bright", "vibrant", "muted", "high-vis", "retro", "high-contrast", "scatter"]
        STYLES["science+$color_style"] = Dict(
            :category => "combinations",
            :description => "Science style with $color_style color scheme",
            :theme => merge(copy(STYLES["science"][:theme]), copy(STYLES[color_style][:theme]))
        )
    end
end

# Initialize all styles
register_base_styles()
register_color_styles()
register_journal_styles()
register_misc_styles()
register_language_styles()
register_combination_styles()

end # module
