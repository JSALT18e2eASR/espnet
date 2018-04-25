# you can change cmd.sh depending on what type of queue you are using.
# If you have no queueing system and want to run on a local machine, you
# can change all instances 'queue.pl' to run.pl (but be careful and run
# commands one by one: most recipes will exhaust the memory on your
# machine).  queue.pl works with GridEngine (qsub).  slurm.pl works
# with slurm.  Different queues are configured differently, with different
# queue names and different ways of specifying things like memory;
# to account for these differences you can create and edit the file
# conf/queue.conf to match your queue's configuration.  Search for
# conf/queue.conf in http://kaldi-asr.org/doc/queue.html for more information,
# or search for the string 'default_config' in utils/queue.pl or utils/slurm.pl.

export train_cmd="run.pl --mem 2G"
export cuda_cmd="run.pl --mem 2G --gpu 1"
export decode_cmd="run.pl --mem 4G"

case $(hostname -d) in
    clsp.jhu.edu) 
	# JHU setup
	export train_cmd="queue.pl --mem 2G"
	export cuda_cmd="queue.pl --mem 2G --gpu 1 --config conf/gpu.conf"
	export decode_cmd="queue.pl --mem 4G"
	;;
    fit.vutbr.cz)
	# BUT setup
	declare -A user2matylda=([iveselyk]=matylda5 [karafiat]=matylda3 [ihannema]=matylda5 [baskar]=matylda6)
	matylda=${user2matylda[$USER]}
	queue="all.q@@blade" #,all.q@@speech"
	#gpu_queue="long.q@@gpu,long.q@@speech-gpu,eval.q"
	gpu_queue="long.q@@gpu,long.q@@speech-gpu"
	#export plain_cmd="run.pl" # Runs locally (initial GMM training),
	export train_cmd="queue.pl -q $queue -l ram_free=1.5G,mem_free=1.5G,${matylda}=0.25"
	export decode_cmd="queue.pl -q $queue -l ram_free=5.5G,mem_free=5.5G,${matylda}=0.5"
	export cuda_cmd="queue.pl -q $gpu_queue -l gpu=1 -l ram_free=1G,mem_free=1G"
	;;
esac
