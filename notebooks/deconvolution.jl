### A Pluto.jl notebook ###
# v0.18.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 17a23f15-53a3-4ec4-a50b-1a3d9eb1a78d
begin
	import Pkg
	Pkg.develop(path="/Users/luis/git/Plots.jl")
	#Pkg.instantiate()
	using Plots
end

# ╔═╡ fa539a20-447e-11ec-0a13-71fa39527f8f
begin
	using PlutoUI
	using DSP
	using DataFrames
	using Unfold
	using StatsModels
	using StatsBase
	using StatsPlots
	using Random
	using Images
	using PlutoUI.ExperimentalLayout: vbox, hbox, Div
	using HypertextLiteral
	using Distributions
	plotly()
	
	html"""
	<style>
		:root {
			--image-filters: invert(1) hue-rotate(180deg) contrast(0.8);
			--out-of-focus-opacity: 0.5;
			--main-bg-color: hsl(0deg 0% 12%);
			--rule-color: rgba(255, 255, 255, 0.15);
			--kbd-border-color: #222222;
			--header-bg-color: hsl(30deg 3% 16%);
			--header-border-color: transparent;
			--ui-button-color: rgb(255, 255, 255);
			--cursor-color: white;
			--normal-cell: 100, 100, 100;
			--error-color: 255, 125, 125;
			--normal-cell-color: rgba(var(--normal-cell), 0.2);
			--dark-normal-cell-color: rgba(var(--normal-cell), 0.4);
			--selected-cell-color: rgb(40 147 189 / 65%);
			--code-differs-cell-color: #9b906c;
			--error-cell-color: rgba(var(--error-color), 0.6);
			--bright-error-cell-color: rgba(var(--error-color), 0.9);
			--light-error-cell-color: rgba(var(--error-color), 0);
			--export-bg-color: hsl(225deg 17% 18%);
			--export-color: rgb(255 255 255 / 84%);
			--export-card-bg-color: rgb(73 73 73);
			--export-card-title-color: rgba(255, 255, 255, 0.85);
			--export-card-text-color: rgb(255 255 255 / 70%);
			--export-card-shadow-color: #0000001c;
			--pluto-schema-types-color: rgba(255, 255, 255, 0.6);
			--pluto-schema-types-border-color: rgba(255, 255, 255, 0.2);
			--pluto-dim-output-color: hsl(0, 0, 70%);
			--pluto-output-color: hsl(0deg 0% 77%);
			--pluto-output-h-color: hsl(0, 0%, 90%);
			--pluto-output-bg-color: var(--main-bg-color);
			--a-underline: #ffffff69;
			--blockquote-color: inherit;
			--blockquote-bg: #2e2e2e;
			--admonition-title-color: black;
			--jl-message-color: rgb(38 90 32);
			--jl-message-accent-color: rgb(131 191 138);
			--jl-info-color: rgb(42 73 115);
			--jl-info-accent-color: rgb(92 140 205);
			--jl-warn-color: rgb(96 90 34);
			--jl-warn-accent-color: rgb(221 212 100);
			--jl-danger-color: rgb(100 47 39);
			--jl-danger-accent-color: rgb(255, 117, 98);
			--jl-debug-color: hsl(288deg 33% 27%);
			--jl-debug-accent-color: hsl(283deg 59% 69%);
			--table-border-color: rgba(255, 255, 255, 0.2);
			--table-bg-hover-color: rgba(193, 192, 235, 0.15);
			--pluto-tree-color: rgb(209 207 207 / 61%);
			--disabled-cell-bg-color: rgba(139, 139, 139, 0.25);
			--selected-cell-bg-color: rgb(42 115 205 / 78%);
			--hover-scrollbar-color-1: rgba(0, 0, 0, 0.15);
			--hover-scrollbar-color-2: rgba(0, 0, 0, 0.05);
			--shoulder-hover-bg-color: rgba(255, 255, 255, 0.05);
			--pluto-logs-bg-color: hsl(240deg 10% 29%);
			--pluto-logs-progress-fill: #5f7f5b;
			--pluto-logs-progress-border: hsl(210deg 35% 72%);
			--nav-h1-text-color: white;
			--nav-filepicker-color: #b6b6b6;
			--nav-filepicker-border-color: #c7c7c7;
			--nav-process-status-bg-color: rgb(82, 82, 82);
			--nav-process-status-color: var(--pluto-output-h-color);
			--restart-recc-header-color: rgb(44 106 157 / 56%);
			--restart-req-header-color: rgb(145 66 60 / 56%);
			--dead-process-header-color: rgba(250, 75, 21, 0.473);
			--loading-header-color: hsl(0deg 0% 20% / 50%);
			--disconnected-header-color: rgba(255, 169, 114, 0.56);
			--binder-loading-header-color: hsl(51deg 64% 90% / 50%);
			--loading-grad-color-1: #a9d4f1;
			--loading-grad-color-2: #d0d4d7;
			--overlay-button-bg: #2c2c2c;
			--overlay-button-border: #c7a74670;
			--overlay-button-color: white;
			--input-context-menu-border-color: rgba(255, 255, 255, 0.1);
			--input-context-menu-bg-color: rgb(39, 40, 47);
			--input-context-menu-soon-color: #b1b1b144;
			--input-context-menu-hover-bg-color: rgba(255, 255, 255, 0.1);
			--input-context-menu-li-color: #c7c7c7;
			--pkg-popup-bg: #3d2f44;
			--pkg-popup-border-color: #574f56;
			--pkg-popup-buttons-bg-color: var(--input-context-menu-bg-color);
			--black: white;
			--white: black;
			--pkg-terminal-bg-color: #252627;
			--pkg-terminal-border-color: #c3c3c388;
			--pluto-runarea-bg-color: rgb(43, 43, 43);
			--pluto-runarea-span-color: hsl(353, 5%, 64%);
			--dropruler-bg-color: rgba(255, 255, 255, 0.1);
			--jlerror-header-color: #d9baba;
			--jlerror-mark-bg-color: rgb(0 0 0 / 18%);
			--jlerror-a-bg-color: rgba(82, 58, 58, 0.5);
			--jlerror-a-border-left-color: #704141;
			--jlerror-mark-color: #b1a9a9;
			--helpbox-bg-color: rgb(30 34 31);
			--helpbox-box-shadow-color: #00000017;
			--helpbox-header-bg-color: #2c3e36;
			--helpbox-header-color: rgb(255 248 235);
			--helpbox-notfound-header-color: rgb(139, 139, 139);
			--helpbox-text-color: rgb(230, 230, 230);
			--code-section-bg-color: rgb(44, 44, 44);
			--code-section-border-color: #555a64;
			--footer-color: #cacaca;
			--footer-bg-color: rgb(38, 39, 44);
			--footer-atag-color: rgb(114, 161, 223);
			--footer-input-border-color: #6c6c6c;
			--footer-filepicker-button-color: black;
			--footer-filepicker-focus-color: #9d9d9d;
			--footnote-border-color: rgba(114, 225, 231, 0.15);
			--undo-delete-box-shadow-color: rgba(213, 213, 214, 0.2);
			--cm-editor-tooltip-border-color: rgba(0, 0, 0, 0.2);
			--cm-editor-li-aria-selected-bg-color: #3271e7;
			--cm-editor-li-aria-selected-color: white;
			--cm-editor-li-notexported-color: rgba(255, 255, 255, 0.5);
			--code-background: hsl(222deg 16% 19%);
			--cm-code-differs-gutters-color: rgb(235 213 28 / 11%);
			--cm-line-numbers-color: #8d86875e;
			--cm-selection-background: hsl(215deg 64% 59% / 48%);
			--cm-selection-background-blurred: hsl(215deg 0% 59% / 48%);
			--cm-editor-text-color: #ffe9fc;
			--cm-comment-color: #e96ba8;
			--cm-atom-color: hsl(8deg 72% 62%);
			--cm-number-color: hsl(271deg 45% 64%);
			--cm-property-color: #f99b15;
			--cm-keyword-color: #ff7a6f;
			--cm-string-color: hsl(20deg 69% 59%);
			--cm-var-color: #afb7d3;
			--cm-var2-color: #06b6ef;
			--cm-macro-color: #82b38b;
			--cm-builtin-color: #5e7ad3;
			--cm-function-color: #f99b15;
			--cm-type-color: hsl(51deg 32% 44%);
			--cm-bracket-color: #a2a273;
			--cm-tag-color: #ef6155;
			--cm-link-color: #815ba4;
			--cm-error-bg-color: #ef6155;
			--cm-error-color: #f7f7f7;
			--cm-matchingBracket-color: white;
			--cm-matchingBracket-bg-color: #c58c237a;
			--cm-placeholder-text-color: rgb(255 255 255 / 20%);
			--autocomplete-menu-bg-color: var(--input-context-menu-bg-color);
			--index-text-color: rgb(199, 199, 199);
			--index-clickable-text-color: rgb(235, 235, 235);
			--docs-binding-bg: #323431;
			--cm-html-color: #00ab85;
			--cm-html-accent-color: #00e7b4;
			--cm-css-color: #ebd073;
			--cm-css-accent-color: #fffed2;
			--cm-css-why-doesnt-codemirror-highlight-all-the-text-aaa: #ffffea;
			--cm-md-color: #a2c9d5;
			--cm-md-accent-color: #00a9d1;
		}
		
		div.plutoui-sidebar.aside {
			position: fixed;
			right: 1rem;
			top: 10rem;
			width: min(80vw, 25%);
			padding: 10px;
			border: 3px solid rgba(0, 0, 0, 0.15);
			border-radius: 10px;
			box-shadow: 0 0 11px 0px #00000010;
			max-height: calc(100vh - 5rem - 56px);
			overflow: auto;
			z-index: 40;
			background: white;
			transition: transform 300ms cubic-bezier(0.18, 0.89, 0.45, 1.12);
			color: var(--pluto-output-color);
			background-color: var(--main-bg-color);
		}

		.second {
			top: 18rem !important;
		}

		.third {
			top: 31.25rem !important;
		}

		.fourth {
			top: 37.75rem !important;
		}
		
		div.plutoui-sidebar.aside.hide {
			transform: translateX(calc(100% - 28px));
		}
		
		.plutoui-sidebar header {
			display: block;
			font-size: 1.5em;
			margin-top: -0.1em;
			margin-bottom: 0.4em;
			padding-bottom: 0.4em;
			margin-left: 0;
			margin-right: 0;
			font-weight: bold;
			border-bottom: 2px solid rgba(0, 0, 0, 0.15);
		}
		
		.plutoui-sidebar.aside.hide .open-sidebar, .plutoui-sidebar.aside:not(.hide) .closed-sidebar, .plutoui-sidebar:not(.aside) .closed-sidebar {
			display: none;
		}

		.sidebar-toggle {
			cursor: pointer;
		}
		
	</style>
	<script>
		document.addEventListener('click', event => {
			if (event.target.classList.contains("sidebar-toggle")) {
				document.querySelectorAll('.plutoui-sidebar').forEach(function(el) {
   					el.classList.toggle("hide");
				});
			}
		});
	</script>
	"""
end

# ╔═╡ 8b39f28e-d889-4f98-9601-380e015b7d35
md"""
# Deconvolution (Overlap-Correction)

Let's get right into it - you are probably asking yourself, what is this about? Do i need to know this? Here is a small motivation...

In state-of-the-art EEG research the experiment setup is highly controlled and simplified in a way to avoid overlaps of stimuli responses. This means often only a single stimulation per trial is presented. But the more complex and realistic the research topic, the more complex gets the experiment design. Up to a point were it isn't anymore possible to avoid overlaps. Examples for this are experiments were eye tracking and EEG is combined or the tracking of EEG data in a free environment. However also classic EEG research experiments often contain overlapping responses as simple as a manual button presses or involuntary microsaccades. 

In this case adequately modeling of those overlaps, different to simple averaging is required! If not further considered, this can lead to wrong interpretations and false reasoning.

This notebook should give an intuition **why** the approach of deconvolution should further be investigated and **what** the consequences of not accounting for overlaps are!
"""

# ╔═╡ fbed300c-0778-480c-bd88-8e8b06f4fc20
md""" #### Deconvolution (Left) vs. Without-Deconvolution (Right)"""

# ╔═╡ 34e215c5-9278-4906-890a-2563c8a87b08
let
	img_path = "comparison.png"
	load(img_path)
end

# ╔═╡ 129ce3d1-93dd-4c75-b56d-f8756e9b5ab9
Plots.default(
		linewidth=2, 
		background_color=:transparent, 
		foreground_color=:white,
		formatter = :plain, 
		legend=:outerbottom
	)

# ╔═╡ 32a4879a-7916-4b33-93cf-1e5a395c62b7
begin
	sidebar = Div([@htl("""<header>
			<span class="sidebar-toggle open-sidebar">🕹</span>
     		<span class="sidebar-toggle closed-sidebar">🕹</span>
			Interactive Sliders
			</header>"""),
		md"""Here are all interactive bits of the notebook at one place.\
		Feel free to change them!"""
	], class="plutoui-sidebar aside")
end

# ╔═╡ a9d99a1d-59f2-4c02-89dd-33c9a27db84a
md"""
# **Intuition to Convolution**
"""

# ╔═╡ 18f302aa-35d5-441e-ad18-a107d4bf9cc4
begin
	# define heaviside function for ploxplot
	H(t) = 0.5 * (sign(t) + 1);
	
	md"""
	Before we start digging deeper into the features and characteristic of deconvolution we should first briefly take a closer look at the topic of convolution.
	
	In math convolution is a operation which takes two functions as input and outputs a third function. Formal, deconvolution of the functions $f$ and $g$ is written as $(f * g)$. But what does this new output function describe?
	
	For this a closer look to the process of convolution helps: \
	Convolving two functions is often described as sliding one function over another. 
	Try sliding the orange function over the blue by changing the value of the slider below.
	"""
end

# ╔═╡ df5a7318-de9f-487d-907b-9535620f95ba
let 
	md"""Change the position of the orange function $(@bind s Slider(-1:0.5:5, default=-1, show_value=true))"""
end

# ╔═╡ 9488f19b-0dab-4c46-8a1f-043946cf6b09
let
	# range
	range = 0:0.01:10
	
	# blue boxplot
	f(t) = H(t-2) - H(t-4) 

	# orange boxplot
	g(t) = H(t-s) - H(t-(s+2)) 

	# compute convolution of f with itself
	conv = DSP.conv(f.(range), f.(range))[1:floor(Int64, length(range))] ./ 100

	# useful points for area shading
	orange_left = s
	orange_right = s + 2
	blue_left = 2
	blue_right = 4

	# compute the shaded area (shared area of orange & red)
	area = Shape([0,0,0,0],[0,0,0,0])
	diff = 0

	# cases where rectangles overlap
	if (orange_left <= blue_left) & (blue_left <= orange_right)
		# if orange left border < blue left border
		diff = orange_right - blue_left
		area = Shape(blue_left .+ [0,diff,diff,0], 0 .+ [0,0,1,1])
	elseif (blue_left < orange_left) & (orange_left < blue_right)
		# if orange left border > blue left border
		diff = blue_right - orange_left
		area = Shape(orange_left .+ [0,diff,diff,0], 0 .+ [0,0,1,1])
	end

	# plotting

	# plot the orange (g) and blue (f) rectangle
	plot([f, g], ylim=(0,3), xlim=(-1.5,7.5), size=(600,200), legend=false)

	# plot convolution (green)
	plot!(0:0.01:5.01, conv[500-200:end-200], color=:green)

	# highlight the overlapping area
	plot!(area, opacity=.2, color="grey")

	# mark the current point where the area corresponds to convolution
	vline!([s+1], linecolor=:white, linestyle=:dash)
	scatter!([(s+1, diff)], color="grey")
end

# ╔═╡ cf1b3813-eb29-47a1-b531-319778d1586e
md"""
\
**Consider the following setup:** \
We want to simulate the measured EEG signal of an experiment. In this experiment we have two different stimuli. Each stimuli evokes a different response. Assume we already know this specific response to each stimuli. 
Additonal we know from the experiment setup at which timepoint each stimulus occurred.
"""

# ╔═╡ ecc0df31-a29b-4d62-8dbf-08b86c35a885
md"""
### **Response to Stimuli / Kernel**

As described above, we need for our simulation of the EEG signal, the isolated response of each stimuli. In the context of convolution this is often called kernel. The following figures show the kernel A (orange) and B (green). \
\
The **response to stimuli A** is modelled by the function $ERP_A(t)$

"""

# ╔═╡ cfba1eb3-aeac-45ff-a563-817516011c3b
begin
	selection_erp_a_bond = md"""Choose the response function for stimulus A: $(
		@bind selection_erp_a Select(
			[1=>"Function1", 2=> "Function2", 3=> "Function3", 4=> "Function4"],
		default=1))"""
end

# ╔═╡ 5d62c314-804c-4cf0-a3fe-fbf9328a3ee1
let 
	md"""Change the value of b $(@bind b Slider([3,5,7], default=5, show_value=true))"""
end

# ╔═╡ 5c941851-09e8-4cc3-8503-92bcd4dce2ec
# selection of response function erp a

if selection_erp_a == 1
	# gaussian derivative
	erp_a(t) = -5(t-b)ℯ^ -0.5(t-b)^2;
	# function in latex
	l_a = Markdown.parse("\$ERP_A(t) = -5(t-$b)ℯ^{-0.5(t-$b)^2}\$")
	
elseif selection_erp_a == 2
	# gaussian-like
	erp_a(t) = 2.5ℯ^(-(t-b)^2);
	# function in latex
	l_a = Markdown.parse("\$ERP_A(t) = 2.5ℯ^{-(t-$b)^2}\$")
	
elseif selection_erp_a == 3
	# boxplot
	erp_a(t) = H(t-1) - H(t-b)
	# function in latex
	l_a = Markdown.parse("\$ERP_A(t) = H(t-1)-H(t-$b)\$")
	
elseif selection_erp_a ==4
	# sharper gaussian / (trying to mimic dirac delta function)
	erp_a(t) = (1/((1/8)*sqrt(π)))ℯ^-((t-b)/(1/8))^2
	# function in latex
	l_a = Markdown.parse("\$ERP_A(t) = \\frac{1}{\\frac{1}{8}\\sqrt{\\pi}} 			\\cdot ℯ^{-(\\frac{t - $(b)}{\\frac{1}{8}})^{2}}\$")
end

# ╔═╡ 6bcb8960-cf0d-47d0-ab10-57bdf0aeb037
begin
	# plot erp_a
	plot(erp_a, xlims=(-2, 10), ylims=(-5,5), linecolor=2, size=(600,200))

	# mark zero / event onset
	vline!([0], linestyle=:dash, linecolor=:white, legend=false)
end

# ╔═╡ 44938813-2cf6-4381-afe7-28758adc0abe
md"""
Analogous to this the **response to stimuli B** is modelled by $ERP_B(t)$. 
"""

# ╔═╡ 1e7d5af3-0f55-4b19-8b1a-bb0cb1e71868
begin
selection_erp_b_bond = md"""Choose the response function for stimulus B: $(
	@bind selection_erp_b Select(
		[1=>"Function1", 2=> "Function2", 3=> "Function3", 4=> "Function4"],
		default=2))"""
end

# ╔═╡ a53b8fd0-e061-4147-9dc1-d6313f392ece
let
	md"""Change the value of d $(@bind d Slider([3,5,7], default=5, show_value=true))"""
end

# ╔═╡ 63887aaf-0aeb-44eb-8349-13d47ce6b873
# selection of response function erp b

if selection_erp_b == 1
	# gaussian derivative
	erp_b(t) = -5(t-d)ℯ^ -0.5(t-d)^2;
	# function in latex
	l_b = Markdown.parse("\$ERP_A(t) = -5(t-$d)ℯ^{-0.5(t-$d)^2}\$")
	
elseif selection_erp_b == 2
	# gaussian-like
	erp_b(t) = 2.5ℯ^(-(t-d)^2);
	# function in latex
	l_b = Markdown.parse("\$ERP_B(t) = 2.5ℯ^{-(t-$d)^2}\$")
	
elseif selection_erp_b == 3
	# boxplot
	erp_b(t) = H(t-1) - H(t-d)
	# function in latex
	l_b = Markdown.parse("\$ERP_B(t) = H(t-1)-H(t-$d)\$")
	
elseif selection_erp_b ==4
	# sharper gaussian / (trying to mimic dirac delta function)
	erp_b(t) = (1/((1/8)*sqrt(π)))ℯ^-((t-d)/(1/8))^2
	# function in latex
	l_b = Markdown.parse("\$ERP_B(t) = \\frac{1}{\\frac{1}{8}\\sqrt{\\pi}} 
		\\cdot ℯ^{-(\\frac{t - $(d)}{\\frac{1}{8}})^{2}}\$")
end

# ╔═╡ ffa5a4be-f4c2-434b-badb-053c7d0b2672
begin
	sidebar2 = Div([
		md""" **Stimuli Response**""",
		selection_erp_a_bond,
		l_a,
		md"""""",
		selection_erp_b_bond,
		l_b,
	], class="plutoui-sidebar aside second")
end

# ╔═╡ 0bb4cf30-6e78-41d0-8fa5-bbef696ef9f6
begin
	# plot erp b
	plot(erp_b, xlims=(-2, 10), ylims=(-5,5), linecolor=1, size=(600,200))
	
	# mark zero / event onset
	vline!([0], linestyle=:dash, linecolor=:white, legend=false)
end

# ╔═╡ 80a5a87f-5a38-4820-933d-228f8166aa91


# ╔═╡ 61e5f8bb-4c24-4eb6-a7d6-31c501a51f05
md"""
### **Event onsets**

The next figure shows the **event onsets**. They are part of the experiment design. Normally in research those event onsets are distributed in such a way that overlapping responses are avoided at all costs. But this is not always possible given  the experiment or research.
To later dicuss the problems of not using overlap-correction, we will not avoid overlapping responses in our simulated EEG data. More: We will enforce them to happen at some level.
\
\
Since we want to create a simulated EEG signal we simply choose 300 random values between 1 and 6000 for each stimuli. The event onsets are visualized in the figure below. The orange vertical line corresponds to the event onsets of stimuli A. The green line to the event onsets of stimuli B. \
\
"""

# ╔═╡ 8300dc2f-8022-4ada-aade-fd3c8263be9d
begin	
	slider_deviation = md"""Change deviation: σ\_1 = $(@bind σ₁ Slider([0, 0.1, 0.2, 0.4, 0.8, 1.6, 3.2, 6.4], default=0.1, show_value=true))"""
end

# ╔═╡ ba43ef93-6d4a-4aee-962b-76e78a1e3188
begin	
	slider_mean = md"""Change mean:μ\_1 = $(@bind μ Slider(0:0.4:2, default=0, 
		show_value=true))"""
end

# ╔═╡ ff745930-696a-4700-a084-5130b2895da4
begin
	sidebar3 = Div([
		md""" **Event onsets**""",
		slider_deviation,
		md"""""",
		slider_mean,
	], class="plutoui-sidebar aside third")
end

# ╔═╡ 4cbafc47-71c7-4dfa-9deb-f1b9ca418426
begin
	# sample event onsets
	event_onsets_a = sort(sample(MersenneTwister(4),1:1000, 100, replace = false))
	event_onsets_b = event_onsets_a + rand(LogNormal(μ, σ₁),100)
	
	# graph of event onsets for stimuli A
	e1 = vline(event_onsets_a, xlims=(0,100), ylims=(0,1), 	
		linecolor=2, linestyle=:dash, label="event onset of stimuli A")

	# graph of event onsets for stimuli B
	e2 = vline!(event_onsets_b, xlims=(0,100),ylims=(0,1), 
		linecolor=1, linestyle=:dash, label="event onset of stimuli B")

	# plotting
	plot(e2, size=(600,200), legend=(0.25, -0.2))
end

# ╔═╡ 22014da2-d95e-4b21-8331-fe8137c2e616


# ╔═╡ 4931b75b-28ab-4b65-b0ef-81ec575a3b20
md"""
### **Convolution of kernels with event onsets**

In our process to simulate the continuous EEG signal, we rely on multiple assumptions. One main assumption is that signals within the brain add up linear. Based on this, we can describe the continuous EEG Signal at each timepoint t as following:
"""

# ╔═╡ 1a30cae6-7709-408b-b005-36d40e76f380
Markdown.parse("\$EEG(t)=∑_{i=1}^{n_A}ERP_A(t-eventOnsetA_i)+∑_{i=1}^{n_B}ERP_B(t-eventOnsetB_i)\$")

# ╔═╡ 3a2b986b-1db4-4644-8b21-97aaad9a8860
md"""
### Is this a convolution?  
Yes indeed. By replacing the event onsets with a vector g with zeros everywhere and 1 at the event onsets, we can reformulate the equation from above:
"""

# ╔═╡ 0352884f-cdb9-4802-9459-ff704118cfed
Markdown.parse("\$EEG(t)=g_A*ERP_A+g_B*ERP_B\$")

# ╔═╡ 35535cfa-4bcf-448e-bc1f-fccab20f7919
md"""
!!! tip \"Take Away!\"
	This is a sum of two convolutions!
"""

# ╔═╡ 36d354d4-ffa8-4ce3-9b97-e2cf623c656e
begin
	# assemble the separate signals via the event onsets
	eeg_a(t) = sum((0, (erp_a(t-a) for a in event_onsets_a if abs(t-a)<10)...))
	eeg_b(t) = sum((0, (erp_b(t-a) for a in event_onsets_b if abs(t-a)<10)...))

	# addition of the separate signals at each timepoint
	eeg(t) = eeg_a(t) .+ eeg_b(t)
end;

# ╔═╡ d9e53857-d59d-4302-b9b9-175c14a87f71
md"""
Computing the EEG signals following the second equation:
```julia
# convert event onsets to vector of 0 and 1
range = 0:0.1:6000
g_A = convert.(Int, [i in event_onsets_A for i in range])
g_B = convert.(Int, [i in event_onsets_B for i in range])
```
```julia
# compute the eeg signal as convolution
eeg = conv(g_A, erp_A.(range)) + conv(g_B, erp_B.(range))
```
```julia
# plot the eeg signal
plot(eeg_, xlims=(0,700), formatter=x->x/10)
```
\
\
""";

# ╔═╡ 4cbaaa15-b1d2-4a4e-b100-51589a026ad3
md""" 
### Simulated EEG signal
How does this sum of convolutions look like? Take a look at the next figure!         

The first graph shows the signals of the convolution of the event onsets with the respective kernel of the stimulus. This results in a signal for each stimulus. The orange signal belongs to stimuli A, the blue to stimuli B. The vertical lines show the event onsets in the respective color. \
The green graph below shows the overall signal. This results from adding up the orange and blue signal at each timepoint.
"""

# ╔═╡ 89fe54a2-c1ff-45d6-93ee-d54a92796fe7
begin
	# range
	r = -10:0.1:70

	# plot cummulative signal of eeg_a and eeg_b
	p1 = plot(r, eeg, xlims=(-10, 70), ylims=(-7,7), legend=false,  linecolor=3)

	# mark zero (t=0)
	vline!([0], linestyle=:dash, linecolor=:white)

	# plot eeg_a and eeg_b with event onsets
	
	# create plot of eeg_a
	p2 = plot(r, eeg_a, xlims=(-10, 70), ylims=(-5,5), legend=false, linecolor=2)

	# create plot of eeg_b
	plot!(r, eeg_b, xlims=(-10, 70), ylims=(-7,7), legend=false, linecolor=1)

	# create plot of event onsets of eeg a
	vline!(event_onsets_a, linecolor=2, linestyle=:dash)

	# create plot of event onsets of eeg b
	vline!(event_onsets_b, linecolor=1, linestyle=:dash)

	# mark zero (t=0)
	vline!([0], linestyle=:dash, linecolor=:white)

	# plot eeg_a, eeg_b and cummulative signal together
	plot(p2, p1, layout=@layout[a;b])
	
end

# ╔═╡ c5b3773a-bdd8-4c1a-b496-da4f555cb97f
begin
	# convert the created function into a event dataframe for unfold

	# create events from event onsets for a and b
	events_a = DataFrame(latency = event_onsets_a, condition_a=1);
	events_b = DataFrame(latency = event_onsets_b, condition_b=1);

	# outer join separate events for a and b
	events = sort(outerjoin(events_a, events_b, on = :latency), [:latency])
	
	# add column intercept=1
	insertcols!(events, 2, :intercept => 1)
	
	# add column type=stimulus
	insertcols!(events, 2, :type => "stimulus")
	
	# set missing values to 0
	events = coalesce.(events, 0);
	
	# scale latency wrt to sampling frequency
	events.latency = events.latency * 10
end;

# ╔═╡ 62f251b7-6aaf-457a-b777-99e1576e81ba
md"""
# **Linear Deconvolution with Unfold**

From here on, lets assume we **measured** the **green signal** from the above in our **eeg experiment**. From our experiment we additional know at which time each respective stimulus was presented (event onsets). Based on this we try to recover the underlying ERP for each stimulus. In our case stimuli A and stimuli B. This is the inverse operation of the above performed convolution. \
\
For illustration purpose we introduce noise to the data. The level of noise is contolled by the \
variable σ.
The greater σ, the more noise is added to the original data. \
\
Feel free to adjust the noise, and see how the quality of the results change.


"""

# ╔═╡ 1ab44014-42de-4811-b5db-b62c9af8b393
begin	
	slider_noise = md"""Change noise: σ = $(@bind σ Slider([0, 0.4, 0.8, 1.6], default=0, show_value=true))"""
end

# ╔═╡ 14df787b-01bb-441b-8a59-658b185bc415
begin
	sidebar4 = Div([
		md""" **Linear Deconvolution**""",
		slider_noise,
		#slider_window
	], class="plutoui-sidebar aside fourth")
end

# ╔═╡ bd06e0c4-4728-4c6f-a1d0-a371c91750fd
begin
	range = 0:0.1:600;
	data = eeg.(range);
	data_noise = data .+ σ .* randn(size(data));
end;

# ╔═╡ 9f8dfb28-a34d-410d-8268-23df13ec2538
let
	# plot cummulative signal with augumented noise
	p1 = plot(range[1:801], data_noise[1:801], xlims=(-10, 70), ylims=(-7,7),  linecolor=3, size=(600, 200))

	# mark zero
	vline!([0], linestyle=:dash, linecolor=:white, legend=false,)
end

# ╔═╡ c99c3e4e-9d65-48b7-9e8a-51abe68e7ac2
Markdown.parse("\$EEG(t)=g_A*ERP_A+g_B*ERP_B\$")

# ╔═╡ ccb6c4bb-eff2-440a-ba89-2fe71d38ed1b
md"""
By taking a closer look at the formula this means the following: 
- We know the measured EEG Signal at each timepoint ($EEG(t))$
- We know the event onsets for each stimuli ($g_A, g_B$)
- We want to recover the isolated response function to each stimuli $ERP_A$ and $ERP_B$
\
To achieve this, **Linear Modeling** comes to our rescue! Why? We can use LMs because of two reasons / assumptions: 

1) The **overlap** for every event onset is always **slightly different**. This makes it possible to disentangle the two separate responses.
2) We assume that two in time following events don't influence each other within the brain. More specific: The first event **does not influence** the **processing** of the second event.
"""

# ╔═╡ 9a042a58-8a54-43ac-b662-663738d8d373
md"""
!!! tip \"Key Idea\"
    Each **timepoint / observed sample** of the EEG signal can be modelled as a **linear combination** of the (possibly) **overlapping responses / kernels**. 
\
This key idea is visualized in the following figure. \
\
On the left side the figure shows the continuous EEG recording together with the event onsets. It is splitted into distinctive samples for each timepoint and forms the vector $y$.\
\
$X_{dc}$ is the timeexpanded designmatrix. The timeexpansion is indicated by the diagonal columns with the value one over time. Time in this case means timesteps after the specific event onset ($\tau$).\

To get the in the figure stated equation the designmatrix is then multplied by the vector b. This gives us an equation which we can optimize for the best fitting betas.

Intuitively this is what we would expect. The response to the event onset at timepoint t=21 influences the value of the $EEG_{21}$ by $b_1$ aswell as the following after $EEG_{21}$, for example $EEG_{22}$ by $b_2$. 
"""

# ╔═╡ 1149272e-179e-4863-888b-04ed76535650
begin
	url = "https://dfzljdn9uc3pi.cloudfront.net/2019/7838/1/fig-2-2x.jpg"
	img = download(url)
	load(img)
end

# ╔═╡ 2b693197-148b-4196-9914-d06f8fa546ea
Div([md"""[https://doi.org/10.7717/peerj.7838/fig-2](https://doi.org/10.7717/peerj.7838/fig-2)"""], style="display: flex;justify-content: center;")

# ╔═╡ c3c4840a-52c5-41ed-841b-26be3ec22f0e
md"""
Take a closer look at the example for $EEG_{25}$. \
\
The equation for $EEG_{25}$ includes 3 weights:
- β₁ : The response to stimuli A at the local time τ=1
- β₅ : The response to stimuli A, 5 seconds after the event onset (τ=5)
- β₉ : The response to stimuli B at the local time τ=4
This tells us that each of those weights accounts to some extend to the value of $EEG_{25}$. Those multiple equations (each for one timepoint) with a slightly different linear combinations of weights allow us to find the best fitting β's to model our data.
"""

# ╔═╡ 369a63f1-5061-4ee6-b390-458e08179ee9
md"""
As additional variable we introduce the window size. Feel free to change the upper bound and inspect the results graph.
"""

# ╔═╡ fa965472-c3f3-40c4-83a7-eb76bec93c80
begin
	slider_window = md"""Change window size τ = (-2.0, $(@bind τ2 Slider([6,12,20],default=12,show_value=true)))"""
end

# ╔═╡ 60e739ff-a8d4-42b8-8b6e-d73e398f8c80
# window size definition for deconvolution with unfold
 τ = (-2, τ2);

# ╔═╡ 77f03312-0261-402e-a69c-60b192e827b1
begin
	# basisfunction via FIR basis
	basisfunction = firbasis(τ=τ, sfreq=10, name="stimulus")
	
	# formula in wilikinson notation
	formula  = @formula 0~0+condition_a+condition_b;

	# map basidfunction & formula into a dict
	bfDict = Dict(Any=>(formula, basisfunction));

	# fit model
	m = fit(UnfoldModel, bfDict, events, data_noise);

	# create result dataframe
	results = coeftable(m);
end;

# ╔═╡ d93765d1-3740-4aaa-96b3-39473adb4ac5
md"""
### Plotting the results
"""

# ╔═╡ cd93445e-42fd-4572-bd07-c44def848860
begin
	# condition A
	cond_a = filter(row->row.coefname=="condition_a", results)
	plot(cond_a.time, cond_a.estimate, ylims=(-5,5), linecolor=2, 
		label="condition A", legend=:outerbottom)

	# condition B
	cond_b = filter(row->row.coefname=="condition_b", results)
	pₒ = plot!(cond_b.time, cond_b.estimate, ylims=(-5,5), linecolor=1, 
		label="condition B", legend=(0.4, -0.1))

	vline!([0], linestyle=:dash, linecolor=:white, label="", xlims=τ)
end

# ╔═╡ d22a9b9c-b57c-4c34-b1e9-fce1392631ee
md""" 

!!! tip \"Take Away !\"
	**Deconvolution recovers the respective kernels** in this case regardless of overlaps!

!!! note \"Question ?\" 
	Does the same apply for the widly used mass-univariate approach?
"""

# ╔═╡ 71b0682e-228b-48fe-8754-a81b42abb948
md"""
# Deconvolution vs. Mass-Univariate

This plot shows the comparison between the **deconvolution with overlap correction** (left) and the **mass-univariate approach** (right).

As a reminder: Feel free to play around with the interaactive parts (at the right side) and compare the results for differnt functions and values.
"""

# ╔═╡ f0f36214-29f6-4483-b39c-4a65b78f5f03
begin
	data_r = reshape(data_noise,(1,:))
	data_epochs, times = Unfold.epoch(data=data_r,tbl=events,τ=τ,sfreq=10);
	f  = @formula 0~0+condition_a+condition_b
	m_ = fit(UnfoldModel, Dict(Any=>(f, times)), events, data_epochs);
	results_ = coeftable(m_)

	# condition A
	condA_ = filter(row->row.coefname=="condition_a", results_)
	plot(condA_.time, condA_.estimate, ylims=(-5,5), linecolor=2, 
		label="", legend=:outerbottom)

	# condition B
	condB_ = filter(row->row.coefname=="condition_b", results_)
	pₘ = plot!(condB_.time, condB_.estimate, ylims=(-5,5), linecolor=1, 
		label="", xlims=τ)
	
	plot(pₒ, pₘ, layout=(1,2), legend=false)
end

# ╔═╡ Cell order:
# ╟─8b39f28e-d889-4f98-9601-380e015b7d35
# ╟─fbed300c-0778-480c-bd88-8e8b06f4fc20
# ╟─34e215c5-9278-4906-890a-2563c8a87b08
# ╟─17a23f15-53a3-4ec4-a50b-1a3d9eb1a78d
# ╟─fa539a20-447e-11ec-0a13-71fa39527f8f
# ╟─129ce3d1-93dd-4c75-b56d-f8756e9b5ab9
# ╟─32a4879a-7916-4b33-93cf-1e5a395c62b7
# ╟─ffa5a4be-f4c2-434b-badb-053c7d0b2672
# ╟─ff745930-696a-4700-a084-5130b2895da4
# ╟─14df787b-01bb-441b-8a59-658b185bc415
# ╟─a9d99a1d-59f2-4c02-89dd-33c9a27db84a
# ╟─18f302aa-35d5-441e-ad18-a107d4bf9cc4
# ╟─df5a7318-de9f-487d-907b-9535620f95ba
# ╟─9488f19b-0dab-4c46-8a1f-043946cf6b09
# ╟─cf1b3813-eb29-47a1-b531-319778d1586e
# ╟─ecc0df31-a29b-4d62-8dbf-08b86c35a885
# ╟─cfba1eb3-aeac-45ff-a563-817516011c3b
# ╟─5d62c314-804c-4cf0-a3fe-fbf9328a3ee1
# ╟─5c941851-09e8-4cc3-8503-92bcd4dce2ec
# ╟─6bcb8960-cf0d-47d0-ab10-57bdf0aeb037
# ╟─44938813-2cf6-4381-afe7-28758adc0abe
# ╟─1e7d5af3-0f55-4b19-8b1a-bb0cb1e71868
# ╟─a53b8fd0-e061-4147-9dc1-d6313f392ece
# ╟─63887aaf-0aeb-44eb-8349-13d47ce6b873
# ╟─0bb4cf30-6e78-41d0-8fa5-bbef696ef9f6
# ╟─80a5a87f-5a38-4820-933d-228f8166aa91
# ╟─61e5f8bb-4c24-4eb6-a7d6-31c501a51f05
# ╟─8300dc2f-8022-4ada-aade-fd3c8263be9d
# ╟─ba43ef93-6d4a-4aee-962b-76e78a1e3188
# ╟─4cbafc47-71c7-4dfa-9deb-f1b9ca418426
# ╟─22014da2-d95e-4b21-8331-fe8137c2e616
# ╟─4931b75b-28ab-4b65-b0ef-81ec575a3b20
# ╟─1a30cae6-7709-408b-b005-36d40e76f380
# ╟─3a2b986b-1db4-4644-8b21-97aaad9a8860
# ╟─0352884f-cdb9-4802-9459-ff704118cfed
# ╟─35535cfa-4bcf-448e-bc1f-fccab20f7919
# ╟─36d354d4-ffa8-4ce3-9b97-e2cf623c656e
# ╟─d9e53857-d59d-4302-b9b9-175c14a87f71
# ╟─4cbaaa15-b1d2-4a4e-b100-51589a026ad3
# ╟─89fe54a2-c1ff-45d6-93ee-d54a92796fe7
# ╟─c5b3773a-bdd8-4c1a-b496-da4f555cb97f
# ╟─62f251b7-6aaf-457a-b777-99e1576e81ba
# ╟─1ab44014-42de-4811-b5db-b62c9af8b393
# ╟─bd06e0c4-4728-4c6f-a1d0-a371c91750fd
# ╟─9f8dfb28-a34d-410d-8268-23df13ec2538
# ╟─c99c3e4e-9d65-48b7-9e8a-51abe68e7ac2
# ╟─ccb6c4bb-eff2-440a-ba89-2fe71d38ed1b
# ╟─9a042a58-8a54-43ac-b662-663738d8d373
# ╟─1149272e-179e-4863-888b-04ed76535650
# ╟─2b693197-148b-4196-9914-d06f8fa546ea
# ╟─c3c4840a-52c5-41ed-841b-26be3ec22f0e
# ╟─369a63f1-5061-4ee6-b390-458e08179ee9
# ╟─fa965472-c3f3-40c4-83a7-eb76bec93c80
# ╟─60e739ff-a8d4-42b8-8b6e-d73e398f8c80
# ╟─77f03312-0261-402e-a69c-60b192e827b1
# ╟─d93765d1-3740-4aaa-96b3-39473adb4ac5
# ╟─cd93445e-42fd-4572-bd07-c44def848860
# ╟─d22a9b9c-b57c-4c34-b1e9-fce1392631ee
# ╟─71b0682e-228b-48fe-8754-a81b42abb948
# ╟─f0f36214-29f6-4483-b39c-4a65b78f5f03
