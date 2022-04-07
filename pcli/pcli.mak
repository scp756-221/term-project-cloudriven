build-pcli:
	# Building pcli based on the external IP address
	make PORT=80 SERVER=$(echo kubectl -n istio-system get service istio-ingressgateway | awk '{print $4}') build-pcli

run-pcli:
	# Running pcli based on the external IP address
	make PORT=80 SERVER=$(echo kubectl -n istio-system get service istio-ingressgateway | awk '{print $4}') run-pcli
	