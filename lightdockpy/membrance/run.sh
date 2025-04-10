#!/bin/bash

################
# You may change these variables according to your needs
COMPLEX="1EXB"
SWARMS=60
GLOWWORMS=200
STEPS=100
CORES=16
################

# # Setup
# rm -rf lightdock* setup.json init/ swarm_*
# cp ../${COMPLEX}_A_noh.pdb ../${COMPLEX}_B_noh.pdb .
# lightdock3_setup.py receptor.pdb ligand.pdb -g ${GLOWWORMS} --noxt --noh --membrane

# # Simulation
# lightdock3.py setup.json 100 -c 16 -s fastdfire 

# Generate predictions in PDB format
swarms=$((SWARMS-1))
for i in $(seq 0 $swarms)
  do
    cd swarm_${i}; lgd_generate_conformations.py ../receptor.pdb ../ligand.pdb  gso_${STEPS}.out ${GLOWWORMS}; cd ..;
  done

# Cluster per swarm
for i in $(seq 0 $swarms)
  do
    cd swarm_${i}; lgd_cluster_bsas.py gso_${STEPS}.out; cd ..;
  done

s=`ls -d ./swarm_* | wc -l`

# Generate ranking of predictions
lgd_rank.py ${s} ${STEPS}

echo "Done."
