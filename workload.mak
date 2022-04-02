check-number_user:
	@if test "$(number_user)" = "" ; then \
		echo "number_user not set"; \
		@exit 1;\
	fi
user:check-number_user
	@./gatling-n-user.sh $(number_user)

music:check-number_user
	@./gatling-n-music.sh $(number_user)

stop:
	@./tools/kill-gatling.sh
