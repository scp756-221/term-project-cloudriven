
user:
	@./gatling-n-user.sh $(number_user)

music:
	@./gatling-n-music.sh $(number_user)

stop:
	@./tools/kill-gatling.sh
