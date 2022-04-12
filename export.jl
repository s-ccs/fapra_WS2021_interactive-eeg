
path_to_dir = abspath("./notebooks/")
@info path_to_dir
using PlutoSliderServer
PlutoSliderServer.export_directory(path_to_dir, Export_output_dir="./output/", Export_offer_binder=false)
