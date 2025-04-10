#!/bin/bash


SWARMS=400
GLOWWORMS=200
STEPS=100


rm -rf lightdock* setup.json init/ swarm_*
lightdock3_setup.py 2UUY_rec.pdb 2UUY_lig.pdb --noxt --noh --now -anm 

lightdock3.py setup.json 100 -c 16



# Generate predictions in PDB format
s=`ls -d ./swarm_* | wc -l`
swarms=$((s-1))
for i in $(seq 0 $swarms)
  do
    cd swarm_${i}; lgd_generate_conformations.py ../2UUY_rec.pdb ../2UUY_lig.pdb  gso_${STEPS}.out ${GLOWWORMS}; cd ..;
  done

# Cluster per swarm
for i in $(seq 0 $swarms)
  do
    cd swarm_${i}; lgd_cluster_bsas.py gso_${STEPS}.out; cd ..;
  done

# Generate ranking of predictions
lgd_rank.py ${s} ${STEPS}