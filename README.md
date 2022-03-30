# Interactive EEG
This is a student project trying to visualize common EEG stuff interactivly via [Pluto.jl](https://github.com/llips/Pluto.jl).

## **Files**
- ``/notebooks`` folder containing the notebooks listed below
    - ``deconvolution.jl``
    - ``clusterPermutation.jl``
    - ``filterArtefacts.jl``
- ``PlutoDeployment.toml`` custom configuration of the pluto slider server
- ``Project.toml`` dependencies
- ``start.jl`` startup script for the pluto slider server

## **Export precomputed notebooks**
- Checkout the branch / pull request [#29](https://github.com/JuliaPluto/PlutoSliderServer.jl/pull/29) (Note that it is still WIP)

- Activate branch of [#29](https://github.com/JuliaPluto/PlutoSliderServer.jl/pull/29) PlutoSliderServer.jl in julia environment of current project 
    ```console
    $ julia --project="."
    ```
    ```console
    julia> ]
    ```
    ```console
    (interactive-eeg) pkg> dev path/to/PlutoSliderServer.jl#29
    ```

- Start precomputing the slider server by running the following:
    ```console
    julia --project="." start.jl
    ```