# run2 script-name throughput threads duration domain 
docker_name="kamal/jmeter:0.01"
timestamp=$(date +%H%M%S%Y%m%d) && start_date=$(date +%Y-%m-%d) && start_time=$(date +%H:%M:%S) && export volume_path=/c/Users/Admin/Scripts && export jmeter_path=/mnt/jmeter && test_script=$1 && docker run -d --env log=result_${timestamp}_${test_script}.jtl --env name=aggregate_${timestamp}_${test_script} --volume ${volume_path}:${jmeter_path} ${docker_name} ls -ltr ${jmeter_path}
timestamp=$(date +%H%M%S%Y%m%d) && start_date=$(date +%Y-%m-%d) && start_time=$(date +%H:%M:%S) && export volume_path=/c/Users/Admin/Scripts && export jmeter_path=/mnt/jmeter && test_script=$1 && docker run -d --env log=result_${timestamp}_${test_script}.jtl --env name=aggregate_${timestamp}_${test_script} --volume ${volume_path}:${jmeter_path} ${docker_name} jmeter -n -Jglobal.throughput=$2 -Jglobal.threads=$3 -Jglobal.duration=$4 -t ${jmeter_path}/${test_script}.jmx -l ${jmeter_path}/tmp/result_${timestamp}_${test_script}.jtl -j ${jmeter_path}/tmp/jmeter_${timestamp}.log
sleep $(($4+45))

docker run -d --volume ${volume_path}:${jmeter_path} ${docker_name} java -Djava.awt.headless=true -classpath "/opt/apache-jmeter-5.0/lib/*:/opt/apache-jmeter-5.0/lib/ext/*" -jar /opt/apache-jmeter-5.0/lib/ext/cmdrunner-2.0.jar --tool Reporter --input-jtl ${jmeter_path}/tmp/result_${timestamp}_${test_script}.jtl --plugin-type AggregateReport --generate-csv ${jmeter_path}/tmp/aggregate_${timestamp}_${test_script}.csv

sleep 45

docker run -d --volume ${volume_path}:${jmeter_path} ${docker_name} jmeter  -g ${jmeter_path}/tmp/result_${timestamp}_${test_script}.jtl  -o ${jmeter_path}/output/${timestamp}${test_script}
