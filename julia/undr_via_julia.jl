using Pkg
using Plots
try
    using PyCall
    using  Conda
    using CondaPkg
    return true
catch e
    Pkg.add("PyCall")
    Pkg.add("Conda")
    Pkg.add("CondaPkg")
    ENV["Python"] = Conda.PYTHONDIR
    Pkg.build("PyCall")
    using CondaPkg
    using PyCall
    using  Conda
    Conda.add("tonic",channel="conda-forge")
    run(`/home/rjjarvis/.julia/conda/3/x86_64/bin/python undr/python/setup.py develop `)
    run(`python3 -m undr init`)
    run(`python3 -m undr install`)
    CondaPkg.add_pip("tonic")   

end
println(Conda.PYTHONDIR)

py"""
def frames_in_julia()
    import tonic
    import tonic.transforms as transforms
    sensor_size = tonic.datasets.NMNIST.sensor_size
    transform = transforms.Compose(
        [
            transforms.Denoise(filter_time=10000),
            transforms.ToFrame(sensor_size=sensor_size, time_window=3000),
        ]
    )
    testset = tonic.datasets.NMNIST(save_to="./data", train=False, transform=transform)
    from torch.utils.data import DataLoader
    testloader = DataLoader(
        testset,
        batch_size=10,
        collate_fn=tonic.collation.PadTensors(batch_first=True),
    )
    frames, targets = next(iter(testloader))
    return (frames, targets)
"""
(frames, targets) = frames_in_julia()
for f in frames
    Plots.heatmap(frames)
end
