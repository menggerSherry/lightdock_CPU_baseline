#!/bin/bash
set -ex
################

if [ -z $dock_base ]
then
    echo "not found envoriment variable : dock_base"
fi

declare -a stringArray
stringArray=("2VXT" "3VLB" "2A1A" "3LVK" "2GTP" "2X9A" "1RKE" "4GAM" "4JCV" "4LW4")
HOME=$dock_base/lightdockpy/bm/
EXE=$dock_base/lightdock-rust-master
export LIGHTDOCK_DATA=${EXE}/data
rm -rf ${HOME}measure_rust.txt
for str in "${stringArray[@]}"; do

echo "prepare $str" >> "${HOME}measure_rust.txt"
COMPLEX=$str
# SWARMS=500
GLOWWORMS=256
STEPS=100
CORES=20
################
cd ${HOME}${COMPLEX}
# # Setup
rm -rf lightdock* setup.json init/ swarm_*
rm -rf *.list
# cp ../${COMPLEX}_A_noh.pdb ../${COMPLEX}_B_noh.pdb .

# rm -rf swarm_*
# rm -rf clustered
start_time=$(date +"%s")

lightdock3_setup.py ${COMPLEX}_r_u.pdb ${COMPLEX}_l_u.pdb -g ${GLOWWORMS} --noxt --noh --now -anm 

lgd_flatten.py lightdock_rec.nm.npy rec_nm.npy
lgd_flatten.py lightdock_lig.nm.npy lig_nm.npy

s=`ls -d swarm_* | wc -l`
swarms=$((s-1))

for i in $(seq 0 $swarms)
  do
    echo "cd swarm_${i}; cp ../lightdock_${COMPLEX}_r_u.pdb .; cp ../lightdock_${COMPLEX}_l_u.pdb .;cp ../rec_nm.npy .;cp ../lig_nm.npy .;${EXE}/target/release/lightdock-rust ../setup.json ../init/initial_positions_${i}.dat 100 dfire; rm -rf lightdock_*.pdb *.npy data;">> task.list;
  done


ant_thony.py -c ${CORES} task.list

# # # Simulation
# lightdock3.py setup.json 100 -c ${CORES} -s fastdfire 

end_time=$(date +"%s")
execution_time=$((end_time - start_time))
rm -rf   init/ swarm_*
echo "Total Execution Time: $execution_time seconds" >> ${HOME}measure_rust.txt

done