# This file is part of Kpax3. License is MIT.

fastafile = "data/proper_aa.fasta"
partition = "data/proper_aa_partition.csv"

x = AminoAcidData(fastafile)
settings = KSettings("../build/test.bin", γ=[0.4; 0.35; 0.25])

R = normalizepartition(partition, x.id)
k = maximum(R)

priorR = EwensPitman(settings.α, settings.θ)
priorC = AminoAcidPriorCol(x.data, settings.γ, settings.r,
                           maxclust=max(k, settings.maxclust))

state = AminoAcidState(x.data, R, priorR, priorC, settings)

writeresults(x, state, "../build/test_results", what=4, verbose=false)

y1 = readall("../build/test_results_partition.csv")
y2 = parse(Float64,
           strip(readall("../build/test_results_logposterior_value.txt")))
y3 = readall("../build/test_results_attributes.csv")
y4 = readall("../build/test_results_characteristic.csv")
y5 = readall("../build/test_results_dataset.txt")

@test y1 == readall(partition)
@test_approx_eq_eps y2 (state.logpR + state.logpC[1] + state.loglik) ε
@test y3 == readall("data/proper_aa_attributes.csv")
@test y4 == readall("data/proper_aa_characteristic.csv")
@test y5 == readall("data/proper_aa_dataset.txt")