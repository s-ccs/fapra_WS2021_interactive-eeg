### A Pluto.jl notebook ###
# v0.19.2

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

# ╔═╡ 17a23f15-53a3-4ec4-a50b-1a3d9eb1a78d
begin
	#import Pkg
	#Pkg.develop(path="/Users/luis/git/Plots.jl")
	#Pkg.instantiate()
	using Plots
	plotly()
	Plots.default(
		linewidth=2, 
		background_color=:transparent, 
		foreground_color=:white,
		formatter = :plain, 
		legend=:outerbottom
	)


end

# ╔═╡ 8b39f28e-d889-4f98-9601-380e015b7d35
md"""
# Deconvolution (Overlap-Correction)
*An interactive exploration by **Luis Lips** under the supervision of **Benedikt Ehinger**.*

Let's get right into it - you are probably asking yourself, what is this about? Do i need to know this? Here is a small motivation...

In state-of-the-art EEG research the experiment setup is highly controlled and simplified in a way to avoid **temporal overlaps** of brain responses to stimuli. This means often, that we ensure to have only a single event per trial. But the more complex and realistic the research topic, the more complex gets the experiment design. Up to a point were it isn't anymore possible to avoid temporal overlap. Examples for this are experiments were eye tracking and EEG is combined or the tracking of EEG data in a free environment. However also classic EEG research experiments often contain overlapping responses as simple as a stimulus with a button press.

In this case adequately modeling of those overlaps, different to simple averaging is required! **If not further considered, this can lead to wrong interpretations and false reasoning.**

This notebook should give an intuition **why** the approach of deconvolution should further be investigated and **what** the consequences of not accounting for overlaps are!
"""

# ╔═╡ fbed300c-0778-480c-bd88-8e8b06f4fc20
md""" #### Deconvolution (Left) vs. Without-Deconvolution (Right)"""

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

As a reminder: Feel free to play around with the interaactive parts (at the right side) and compare the results for different functions and values.
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

# ╔═╡ 34e215c5-9278-4906-890a-2563c8a87b08
let
	#img_path = "comparison.png"
	#load(img_path)
		plot(pₒ, pₘ, layout=(1,2), legend=false)
end

# ╔═╡ 14df787b-01bb-441b-8a59-658b185bc415
begin
	sidebar4 = Div([
		md""" **Linear Deconvolution**""",
		slider_noise,
		#slider_window
	], class="plutoui-sidebar aside fourth")
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

# ╔═╡ ff745930-696a-4700-a084-5130b2895da4
begin
	sidebar3 = Div([
		md""" **Event onsets**""",
		slider_deviation,
		md"""""",
		slider_mean,
	], class="plutoui-sidebar aside third")
end

# ╔═╡ 129ce3d1-93dd-4c75-b56d-f8756e9b5ab9


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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DSP = "717857b8-e6f2-59f4-9121-6e50c889abd2"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
StatsModels = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
StatsPlots = "f3b207a7-027a-5e70-b257-86293d7955fd"
Unfold = "181c99d8-e21b-4ff3-b70b-c233eddec679"

[compat]
DSP = "~0.7.5"
DataFrames = "~1.3.2"
Distributions = "~0.25.53"
HypertextLiteral = "~0.9.3"
Images = "~0.25.1"
Plots = "~1.27.5"
PlutoUI = "~0.7.38"
StatsBase = "~0.33.16"
StatsModels = "~0.6.29"
StatsPlots = "~0.14.33"
Unfold = "~0.3.11"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AMD]]
deps = ["Libdl", "LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "fc66ffc5cff568936649445f58a55b81eaf9592c"
uuid = "14f7f29c-3bd6-536c-9a0b-7339e30b5a3e"
version = "0.4.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "62e51b39331de8911e4a7ff6f5aaf38a5f4cc0ae"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.2.0"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "288d58589d4249a63095f3f41ece91bf34c32c19"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.0"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "4c31b0101997beb213a9e6c39116b052e73ca38c"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.8.0+0"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "c933ce606f6535a7c7b98e1d86d5d1014f730596"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.7"

[[deps.Arrow]]
deps = ["ArrowTypes", "BitIntegers", "CodecLz4", "CodecZstd", "DataAPI", "Dates", "Mmap", "PooledArrays", "SentinelArrays", "Tables", "TimeZones", "UUIDs"]
git-tree-sha1 = "85013d248b128cf13ae62c827c4bf05872e97f78"
uuid = "69666777-d1a9-59fb-9406-91d4454c9d45"
version = "2.2.1"

[[deps.ArrowTypes]]
deps = ["UUIDs"]
git-tree-sha1 = "a0633b6d6efabf3f76dacd6eb1b3ec6c42ab0552"
uuid = "31f734f8-188a-4ce0-8406-c8a06bd891cd"
version = "1.2.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "cf6875678085aed97f52bfc493baaebeb6d40bcb"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.5"

[[deps.BSplines]]
deps = ["LinearAlgebra", "OffsetArrays", "RecipesBase"]
git-tree-sha1 = "5b609325fcb8f5fc124351b9267183722965860d"
uuid = "488c2830-172b-11e9-1591-253b8a7df96d"
version = "0.3.3"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Printf", "Statistics"]
git-tree-sha1 = "90b73db83791c5f83155016dd1cc1f684d4e1361"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "0.4.3"

[[deps.BitIntegers]]
deps = ["Random"]
git-tree-sha1 = "5a814467bda636f3dde5c4ef83c30dd0a19928e0"
uuid = "c3b6d118-76ef-56ca-8cc7-ebb389d030a1"
version = "0.2.6"

[[deps.BlockDiagonals]]
deps = ["ChainRulesCore", "FillArrays", "FiniteDifferences", "LinearAlgebra"]
git-tree-sha1 = "e256e3aefd8041524f7338f655caa42329a31f5b"
uuid = "0a1fb500-61f7-11e9-3c65-f5ef3456f9f0"
version = "0.1.26"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[deps.CategoricalArrays]]
deps = ["DataAPI", "Future", "Missings", "Printf", "Requires", "Statistics", "Unicode"]
git-tree-sha1 = "109664d3a6f2202b1225478335ea8fea3cd8706b"
uuid = "324d7699-5711-5eae-9e2f-1d82baa6b597"
version = "0.10.5"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "75479b7df4167267d75294d14b58244695beb2ac"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.2"

[[deps.CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[deps.CodecLz4]]
deps = ["Lz4_jll", "TranscodingStreams"]
git-tree-sha1 = "59fe0cb37784288d6b9f1baebddbf75457395d40"
uuid = "5ba52731-8f18-5e0d-9241-30f10d1ec561"
version = "0.4.0"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.CodecZstd]]
deps = ["CEnum", "TranscodingStreams", "Zstd_jll"]
git-tree-sha1 = "849470b337d0fa8449c21061de922386f32949d9"
uuid = "6b39b394-51ab-5f42-8807-6242bab2b4c2"
version = "0.7.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CommonSolve]]
git-tree-sha1 = "68a0743f578349ada8bc911a5cbd5a2ef6ed6d1f"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.0"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f74e9d5388b8620b4cee35d4c5a618dd4dc547f4"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.3.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[deps.DSP]]
deps = ["Compat", "FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "3e03979d16275ed5d9078d50327332c546e24e68"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.7.5"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "ae02104e835f219b8930c7664b8012c93475c340"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.DataValues]]
deps = ["DataValueInterfaces", "Dates"]
git-tree-sha1 = "d88a19299eba280a6d062e135a43f00323ae70bf"
uuid = "e7dc6d0d-1eca-5fa6-8ad6-5aecde8b7ea5"
version = "0.4.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "dd933c4ef7b4c270aacd4eb88fa64c147492acf0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.10.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "5a4168170ede913a2cd679e53c2123cb4b889795"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.53"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Effects]]
deps = ["DataFrames", "ForwardDiff", "LinearAlgebra", "Statistics", "StatsBase", "StatsModels", "Tables"]
git-tree-sha1 = "3c8098ee42c3227d1b7d602a4386f69e11dfb48f"
uuid = "8f03c58b-bd97-4933-a826-f71b64d2cca2"
version = "0.1.6"

[[deps.EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "d064b0340db45d48893e7604ec95e7a2dc9da904"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.5.0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.ExprTools]]
git-tree-sha1 = "56559bbef6ca5ea0c0818fa5c90320398a6fbf8d"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.8"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "505876577b5481e50d089c1c68899dfb6faebc62"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.6"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "80ced645013a5dbdc52cf70329399c35ce007fae"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.13.0"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FiniteDifferences]]
deps = ["ChainRulesCore", "LinearAlgebra", "Printf", "Random", "Richardson", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "0ee1275eb003b6fc7325cb14301665d1072abda1"
uuid = "26cc04aa-876d-5657-8c51-4c34ba976000"
version = "0.12.24"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "1bd6fc0c344fc0cbee1f42f8d2e7ec8253dda2d2"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.25"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GLM]]
deps = ["Distributions", "LinearAlgebra", "Printf", "Reexport", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "StatsModels"]
git-tree-sha1 = "609115155b0dc532fa5130de65ed086efd27bfbd"
uuid = "38e38edf-8417-5370-95a0-9cbb8c7f171a"
version = "1.6.2"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Ghostscript_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78e2c69783c9753a91cdae88a8d432be85a2ab5e"
uuid = "61579ee1-b43e-5ca0-a5da-69d92c66a64b"
version = "9.55.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "57c021de207e234108a6f1454003120a1bf350c4"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.6.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "SpecialFunctions", "Test"]
git-tree-sha1 = "65e4589030ef3c44d3b90bdc5aac462b4bb05567"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.8"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.ImageAxes]]
deps = ["AxisArrays", "ImageBase", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "c54b581a83008dc7f292e205f4c409ab5caa0f04"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.10"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageContrastAdjustment]]
deps = ["ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "0d75cafa80cf22026cea21a8e6cf965295003edc"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.10"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[deps.ImageDistances]]
deps = ["Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "7a20463713d239a19cbad3f6991e404aca876bda"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.15"

[[deps.ImageFiltering]]
deps = ["CatIndices", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageBase", "ImageCore", "LinearAlgebra", "OffsetArrays", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "15bd05c1c0d5dbb32a9a3d7e0ad2d50dd6167189"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.7.1"

[[deps.ImageIO]]
deps = ["FileIO", "JpegTurbo", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "464bdef044df52e6436f8c018bea2d48c40bb27b"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.1"

[[deps.ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils", "Libdl", "Pkg", "Random"]
git-tree-sha1 = "5bc1cb62e0c5f1005868358db0692c994c3a13c6"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.1"

[[deps.ImageMagick_jll]]
deps = ["Artifacts", "Ghostscript_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "f025b79883f361fa1bd80ad132773161d231fd9f"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.12+2"

[[deps.ImageMetadata]]
deps = ["AxisArrays", "ImageAxes", "ImageBase", "ImageCore"]
git-tree-sha1 = "36cbaebed194b292590cba2593da27b34763804a"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.8"

[[deps.ImageMorphology]]
deps = ["ImageCore", "LinearAlgebra", "Requires", "TiledIteration"]
git-tree-sha1 = "7668b123ecfd39a6ae3fc31c532b588999bdc166"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.3.1"

[[deps.ImageQualityIndexes]]
deps = ["ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "OffsetArrays", "Statistics"]
git-tree-sha1 = "1d2d73b14198d10f7f12bf7f8481fd4b3ff5cd61"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.3.0"

[[deps.ImageSegmentation]]
deps = ["Clustering", "DataStructures", "Distances", "Graphs", "ImageCore", "ImageFiltering", "ImageMorphology", "LinearAlgebra", "MetaGraphs", "RegionTrees", "SimpleWeightedGraphs", "StaticArrays", "Statistics"]
git-tree-sha1 = "36832067ea220818d105d718527d6ed02385bf22"
uuid = "80713f31-8817-5129-9cf8-209ff8fb23e1"
version = "1.7.0"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "d0ac64c9bee0aed6fdbb2bc0e5dfa9a3a78e3acc"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.3"

[[deps.ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "ImageBase", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "42fe8de1fe1f80dab37a39d391b6301f7aeaa7b8"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.9.4"

[[deps.Images]]
deps = ["Base64", "FileIO", "Graphics", "ImageAxes", "ImageBase", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageSegmentation", "ImageShow", "ImageTransformations", "IndirectArrays", "IntegralArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "11d268adba1869067620659e7cdf07f5e54b6c76"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.25.1"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IncompleteLU]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "a22b92ffedeb499383720dfedcd473deb9608b62"
uuid = "40713840-3770-5561-ab4c-a76e7d0d7895"
version = "0.2.0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "61feba885fac3a407465726d0c330b3055df897f"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.2"

[[deps.IntegralArrays]]
deps = ["ColorTypes", "FixedPointNumbers", "IntervalSets"]
git-tree-sha1 = "cf737764159c66b95cdbf5c10484929b247fecfe"
uuid = "1d092043-8f09-5a30-832f-7509e371ab51"
version = "0.1.3"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b15fc0a95c564ca2e0a7ae12c1f095ca848ceb31"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.5"

[[deps.IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "bcf640979ee55b652f3b01650444eb7bbe3ea837"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.4"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IterativeSolvers]]
deps = ["LinearAlgebra", "Printf", "Random", "RecipesBase", "SparseArrays"]
git-tree-sha1 = "1169632f425f79429f245113b775a0e3d121457c"
uuid = "42fd0dbc-a981-5370-80f2-aaf504508153"
version = "0.9.2"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLD2]]
deps = ["FileIO", "MacroTools", "Mmap", "OrderedCollections", "Pkg", "Printf", "Reexport", "TranscodingStreams", "UUIDs"]
git-tree-sha1 = "81b9477b49402b47fbe7f7ae0b252077f53e4a08"
uuid = "033835bb-8acc-5ee8-8aae-3f567f8a3819"
version = "0.4.22"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "8c1f668b24d999fb47baf80436194fdccec65ad2"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.9.4"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "591e8dc09ad18386189610acafb970032c519707"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.3"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "a024280a69c49f51ba29d2deb66f07508f0b9b49"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.7.13"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LDLFactorizations]]
deps = ["AMD", "LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "399bbe845e06e1c2d44ebb241f554d45eaf66788"
uuid = "40e66cde-538c-5869-a4ad-c39174c6795b"
version = "0.8.1"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "6f14549f7760d84b2db7a9b10b88cd3cc3025730"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.14"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LeftChildRightSiblingTrees]]
deps = ["AbstractTrees"]
git-tree-sha1 = "b864cb409e8e445688bc478ef87c0afe4f6d1f8d"
uuid = "1d6d02ad-be62-4b6b-8a6d-2f90e265016e"
version = "0.1.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearOperators]]
deps = ["FastClosures", "LDLFactorizations", "LinearAlgebra", "Printf", "SparseArrays", "TimerOutputs"]
git-tree-sha1 = "327ebc4bb8baa48f1bbf250d18045c20bbbfdd55"
uuid = "5c8ed15e-5a4c-59e4-a42b-c7e8811fb125"
version = "2.2.3"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "58f25e56b706f95125dcb796f39e1fb01d913a71"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.10"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Lz4_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "5d494bc6e85c4c9b626ee0cab05daa4085486ab1"
uuid = "5ced341a-0733-55b8-9ab6-a4889d929147"
version = "1.9.3+0"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "e595b205efd49508358f7dc670a940c790204629"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.0.0+0"

[[deps.MLBase]]
deps = ["IterTools", "Random", "Reexport", "StatsBase"]
git-tree-sha1 = "3bd9fd4baf19dfc1edf344bc578da7f565da2e18"
uuid = "f0e99cf1-93fa-52ec-9ecc-5026115318e0"
version = "0.9.0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathOptInterface]]
deps = ["BenchmarkTools", "LinearAlgebra", "OrderedCollections", "SparseArrays", "Test", "Unicode"]
git-tree-sha1 = "78427dcc212e0c0ad9658049bc56a50303ad9737"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "0.9.7"

[[deps.MathProgBase]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9abbe463a1e9fc507f12a69e7f29346c2cdc472c"
uuid = "fdba3010-5040-5b88-9595-932c9decdf73"
version = "0.7.8"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.MetaGraphs]]
deps = ["Graphs", "JLD2", "Random"]
git-tree-sha1 = "2af69ff3c024d13bde52b34a2a7d6887d4e7b438"
uuid = "626554b9-1ddb-594c-aa3c-2596fe9399a5"
version = "0.7.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.MixedModels]]
deps = ["Arrow", "DataAPI", "Distributions", "GLM", "JSON3", "LazyArtifacts", "LinearAlgebra", "Markdown", "NLopt", "PooledArrays", "ProgressMeter", "Random", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "StatsFuns", "StatsModels", "StructTypes", "Tables"]
git-tree-sha1 = "64bd164a79a4a27ef56db494e14e0cf6e76c3658"
uuid = "ff71e718-51f3-5ec2-a782-8ffcbfa3c316"
version = "4.6.1"

[[deps.MixedModelsPermutations]]
deps = ["BlockDiagonals", "LinearAlgebra", "MixedModels", "Random", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "StatsModels", "Tables"]
git-tree-sha1 = "a08c290a3b4770866c25c732aad6b38d196a041e"
uuid = "647c4018-d7ef-4d03-a0cc-8889a722319e"
version = "0.1.4"

[[deps.MixedModelsSim]]
deps = ["LinearAlgebra", "MixedModels", "PooledArrays", "PrettyTables", "Random", "Statistics", "Tables"]
git-tree-sha1 = "96ce9a3dd9499fd679a4ffd494d339d50248da0e"
uuid = "d5ae56c5-23ca-4a1f-b505-9fc4796fc1fe"
version = "0.2.6"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "7008a3412d823e29d370ddc77411d593bd8a3d03"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.9.1"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "ba8c0f8732a24facba709388c74ba99dcbfdda1e"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.0"

[[deps.NLopt]]
deps = ["MathProgBase", "NLopt_jll"]
git-tree-sha1 = "48d523294d66f34d012e224ec3082d35c395ebd2"
uuid = "76087f3c-5699-56af-9a33-bf431cd00edd"
version = "0.6.0"

[[deps.NLopt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9b1f15a08f9d00cdb2761dcfa6f453f5d0d6f973"
uuid = "079eb43e-fd8e-5478-9966-2cf3e3edb778"
version = "2.7.1+0"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded92de95031d4a8c61dfb6ba9adb6f1d8016ddd"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.10"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Observables]]
git-tree-sha1 = "fe29afdef3d0c4a8286128d4e45cc50621b1e43d"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.4.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e8185b83b9fc56eb6456200e873ce598ebc7f262"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.7"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "eb4dbb8139f6125471aa3da98fb70f02dc58e49c"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.14"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgBenchmark]]
deps = ["BenchmarkTools", "Dates", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Pkg", "Printf", "TerminalLoggers", "UUIDs"]
git-tree-sha1 = "6e2856f677f8dcab289ded9c3ffb018fad38f29c"
uuid = "32113eaa-f34f-5b0d-bd6c-c81e245fc73d"
version = "0.2.10"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "88ee01b02fba3c771ac4dce0dfc4ecf0cb6fb772"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "0107e2f7f90cc7f756fee8a304987c574bbd7583"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.0.0"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "28ef6c7ce353f0b35d0df0d5930e0d072c1f5b9b"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressLogging]]
deps = ["Logging", "SHA", "UUIDs"]
git-tree-sha1 = "80d919dee55b9c50e8d9e2da5eeafff3fe58b539"
uuid = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
version = "0.1.4"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "1fc929f47d7c151c839c5fc1375929766fb8edcc"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.1"

[[deps.PyMNE]]
deps = ["PyCall"]
git-tree-sha1 = "b3caa6ea95490974465487d54fc1e62a094bad8e"
uuid = "6c5003b2-cbe8-491c-a0d1-70088e6a0fd6"
version = "0.1.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.QPSReader]]
deps = ["Logging", "Pkg"]
git-tree-sha1 = "374833c0c1fd5cc623278581bf0c8259d7b35f10"
uuid = "10f199a5-22af-520b-b891-7ce84a7b1bd0"
version = "0.2.1"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.Quaternions]]
deps = ["DualNumbers", "LinearAlgebra", "Random"]
git-tree-sha1 = "3754f35199da1bb4a55211ddbfd64cb1efee2272"
uuid = "94ee1d12-ae83-5a48-8b1c-48b8ff168ae0"
version = "0.5.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RegionTrees]]
deps = ["IterTools", "LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "4618ed0da7a251c7f92e869ae1a19c74a7d2a7f9"
uuid = "dee08c22-ab7f-5625-9660-a9af2021b33f"
version = "0.3.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Richardson]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "e03ca566bec93f8a3aeb059c8ef102f268a38949"
uuid = "708f8203-808e-40c0-ba2d-98a6953ed40d"
version = "1.4.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.RobustModels]]
deps = ["Distributions", "Future", "GLM", "IterativeSolvers", "LinearAlgebra", "Printf", "QuadGK", "Random", "Roots", "SparseArrays", "Statistics", "StatsBase", "StatsModels", "Tulip"]
git-tree-sha1 = "1363a09a9e58b5a0c7230c98086cd50c77929f53"
uuid = "d6ea1423-9682-4bbd-952f-b1577cbf8c98"
version = "0.4.3"

[[deps.Roots]]
deps = ["CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "838b60ee62bebc794864c880a47e331e00c47505"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "1.4.1"

[[deps.Rotations]]
deps = ["LinearAlgebra", "Quaternions", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "a167638e2cbd8ac41f9cd57282cab9b042fa26e6"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "6a2f7d70512d205ca8c7ee31bfa9f142fe74310c"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.12"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "Requires"]
git-tree-sha1 = "38d88503f695eb0301479bc9b0d4320b378bafe5"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "0.8.2"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.ShiftedArrays]]
git-tree-sha1 = "22395afdcf37d6709a5a0766cc4a5ca52cb85ea0"
uuid = "1277b4bf-5013-50f5-be3d-901d8477a67a"
version = "1.0.0"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleWeightedGraphs]]
deps = ["Graphs", "LinearAlgebra", "Markdown", "SparseArrays", "Test"]
git-tree-sha1 = "a6f404cc44d3d3b28c793ec0eb59af709d827e4e"
uuid = "47aef6b3-ad0c-573a-a1e2-d07658019622"
version = "1.2.1"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "87e9954dfa33fd145694e42337bdd3d5b07021a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "4f6ec5d99a28e1a749559ef7dd518663c5eca3d5"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "72e6abd6fc9ef0fa62a159713c83b7637a14b2b8"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.17"

[[deps.StatsModels]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "Printf", "REPL", "ShiftedArrays", "SparseArrays", "StatsBase", "StatsFuns", "Tables"]
git-tree-sha1 = "03c99c7ef267c8526953cafe3c4239656693b8ab"
uuid = "3eaba693-59b7-5ba5-a881-562e759f1c8d"
version = "0.6.29"

[[deps.StatsPlots]]
deps = ["AbstractFFTs", "Clustering", "DataStructures", "DataValues", "Distributions", "Interpolations", "KernelDensity", "LinearAlgebra", "MultivariateStats", "Observables", "Plots", "RecipesBase", "RecipesPipeline", "Reexport", "StatsBase", "TableOperations", "Tables", "Widgets"]
git-tree-sha1 = "4d9c69d65f1b270ad092de0abe13e859b8c55cad"
uuid = "f3b207a7-027a-5e70-b257-86293d7955fd"
version = "0.14.33"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "d24a825a95a6d98c385001212dc9020d609f2d4f"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.8.1"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.TerminalLoggers]]
deps = ["LeftChildRightSiblingTrees", "Logging", "Markdown", "Printf", "ProgressLogging", "UUIDs"]
git-tree-sha1 = "62846a48a6cd70e63aa29944b8c4ef704360d72f"
uuid = "5d786b92-1e48-4d6f-9151-6b4477ca9bed"
version = "0.1.5"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "aaa19086bc282630d82f818456bc40b4d314307d"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.4"

[[deps.TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[deps.TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "0a359b0ee27e4fbc90d9b3da1f48ddc6f98a0c9e"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.7.3"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "d60b0c96a16aaa42138d5d38ad386df672cb8bd8"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.16"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.Tulip]]
deps = ["CodecBzip2", "CodecZlib", "Krylov", "LDLFactorizations", "LinearAlgebra", "LinearOperators", "Logging", "MathOptInterface", "Printf", "QPSReader", "SparseArrays", "SuiteSparse", "Test", "TimerOutputs"]
git-tree-sha1 = "753c5bd161ca2a64da995a21900bcc177bd7d8e4"
uuid = "6dd1b50a-3aae-11e9-10b5-ef983d2400fa"
version = "0.8.0"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unfold]]
deps = ["BSplines", "CategoricalArrays", "DSP", "DataFrames", "Distributions", "DocStringExtensions", "Effects", "GLM", "IncompleteLU", "IterativeSolvers", "LinearAlgebra", "Logging", "MLBase", "Missings", "MixedModels", "MixedModelsPermutations", "MixedModelsSim", "PkgBenchmark", "ProgressMeter", "PyMNE", "Random", "RobustModels", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "StatsFuns", "StatsModels", "Tables", "Test", "TimerOutputs"]
git-tree-sha1 = "6137a1e288f9655a88bd62c34ea91ee7d0ffd01c"
uuid = "181c99d8-e21b-4ff3-b70b-c233eddec679"
version = "0.3.11"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "505c31f585405fc375d99d02588f6ceaba791241"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.5"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─8b39f28e-d889-4f98-9601-380e015b7d35
# ╟─fbed300c-0778-480c-bd88-8e8b06f4fc20
# ╟─34e215c5-9278-4906-890a-2563c8a87b08
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
# ╟─14df787b-01bb-441b-8a59-658b185bc415
# ╟─fa539a20-447e-11ec-0a13-71fa39527f8f
# ╟─ffa5a4be-f4c2-434b-badb-053c7d0b2672
# ╟─ff745930-696a-4700-a084-5130b2895da4
# ╟─129ce3d1-93dd-4c75-b56d-f8756e9b5ab9
# ╟─32a4879a-7916-4b33-93cf-1e5a395c62b7
# ╟─17a23f15-53a3-4ec4-a50b-1a3d9eb1a78d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
