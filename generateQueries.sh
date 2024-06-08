#!/bin/bash

usage() {
    echo "Usage: $0 -s <seed> -n <streams>"
    exit 1
}

while getopts ":s:n:" options; do
    case "${options}" in
        s)
            seed=${OPTARG}
            if [[ $seed -lt 10 || $seed%10 -ne 0 ]]; then
                usage
            fi
            ;;
        n)
            streams=${OPTARG}
            if [[ $streams -lt 0 || $streams -gt 100 ]]; then
                usage
            fi
            ;;
        *)
            usage
            ;;
    esac
done

# Input validation
if [[ -z ${seed} || -z ${streams} ]]; then
    usage
fi

# Copy files from ./queries to current directory
cp ./queries/*.sql ./

# Creating directories
initial_seed=$seed
end_seed=$(( $seed + $streams))
for ((i=$initial_seed; i<=$end_seed; i++)); do
  mkdir -p ./queries/${i}
done

# Creating SQL files
for ((i=$initial_seed; i<=$end_seed; i++)); do
  for j in {1..22}; do 
    sudo ./qgen $j -s 1 -r $i > ./queries/${i}/${j}.sql
  done
done

# Creating and moving refresh function files
counter=1
for ((i=$initial_seed+1; i<=$end_seed; i++)); do
  sudo ./dbgen -U ${counter}
  mv lineitem.tbl.u${counter} ./queries/${i}/
  mv orders.tbl.u${counter} ./queries/${i}/
  mv delete.${counter} ./queries/${i}/
  counter=$((counter+1))
done
