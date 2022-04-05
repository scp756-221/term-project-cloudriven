help:
	@echo ""
	@echo "Creating a workload:"
	@echo "	user     => Example: make -f workload.mak user number_user=5"
	@echo "	music    => Example: make -f workload.mak music number_user=5"
	@echo " playlist => Example: make -f workload.mak playlist number_user=5"
	@echo ""
	@echo "deleting all workloads:"	
	@echo "	user     => Example: make -f workload.mak stop"


check-number_user:
	@if test "$(number_user)" = "" ; then \
		echo "number_user not set"; \
		@exit 1;\
	fi
user:check-number_user
	@./gatling-n-user.sh $(number_user)

music:check-number_user
	@./gatling-n-music.sh $(number_user)

playlist:check-number_user
	@./gatling-n-playlist.sh $(number_user)

stop:
	@./tools/kill-gatling.sh
