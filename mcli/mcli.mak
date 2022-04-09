build-mcli:
	# Building mcli based on the external IP address
	make PORT=80 SERVER=$(echo kubectl -n istio-system get service istio-ingressgateway | awk '{print $4}') build-mcli

run-mcli:
	# Running mcli based on the external IP address
	make PORT=80 SERVER=$(echo kubectl -n istio-system get service istio-ingressgateway | awk '{print $4}') run-mcli