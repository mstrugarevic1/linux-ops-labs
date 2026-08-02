SHELL := /bin/sh

.PHONY: help smoke clean-all shell \
	lab01-start lab01-logs lab01-shell lab01-clean lab01-fix lab01-reset \
	lab02-start lab02-logs lab02-shell lab02-clean lab02-fix lab02-reset \
	lab03-start lab03-logs lab03-shell lab03-clean lab03-fix lab03-reset \
	lab04-start lab04-disk lab04-inodes lab04-deleted-file lab04-logs lab04-shell lab04-clean \
	lab05-start lab05-logs lab05-shell lab05-db lab05-clean lab05-fix lab05-reset \
	lab06-start lab06-logs lab06-shell lab06-clean lab06-fix lab06-reset \
	lab07-start lab07-logs lab07-shell lab07-clean lab07-fix lab07-reset \
	lab08-start lab08-logs lab08-shell lab08-clean lab08-fix lab08-reset \
	lab09-start lab09-logs lab09-shell lab09-clean lab09-fix lab09-reset

LAB01 = docker compose -f lab01-fd-leak/compose.yaml
LAB02 = docker compose -f lab02-blocked-io/compose.yaml
LAB03 = docker compose -f lab03-memory-oom/compose.yaml
LAB04 = docker compose -f lab04-disk-inodes/compose.yaml
LAB05 = docker compose -f lab05-mysql-contention/compose.yaml
LAB06 = docker compose -f lab06-retry-storm/compose.yaml
LAB07 = docker compose -f lab07-dns-resolution/compose.yaml
LAB08 = docker compose -f lab08-cpu-throttling/compose.yaml
LAB09 = docker compose -f lab09-tcp-port-exhaustion/compose.yaml
SERVICE ?= disk

help:
	@printf '%s\n' \
		'Linux troubleshooting labs' \
		'' \
		'Common targets:' \
		'  make labNN-start       start a lab' \
		'  make labNN-logs        follow recent logs' \
		'  make labNN-shell       shell into the main container' \
		'  make labNN-fix         apply the minimal fix patch, where available' \
		'  make labNN-reset       reverse the fix patch, where available' \
		'  make labNN-clean       remove containers and volumes' \
		'  make smoke             syntax-check Python lab files' \
		'  make clean-all         remove all lab containers and volumes' \
		'' \
		'Lab04 scenarios:' \
		'  make lab04-disk' \
		'  make lab04-inodes' \
		'  make lab04-deleted-file' \
		'  make lab04-shell SERVICE=disk|inodes|deleted-file'

smoke:
	python3 -m py_compile lab01-fd-leak/app.py lab02-blocked-io/app.py lab03-memory-oom/app.py lab05-mysql-contention/app.py lab06-retry-storm/client.py lab06-retry-storm/server.py lab07-dns-resolution/app.py lab08-cpu-throttling/app.py lab09-tcp-port-exhaustion/app.py

clean-all: lab01-clean lab02-clean lab03-clean lab04-clean lab05-clean lab06-clean lab07-clean lab08-clean lab09-clean

shell:
	$(LAB04) exec disk bash -il

lab01-start:
	$(LAB01) up --build -d

lab01-logs:
	$(LAB01) logs -f --tail=80

lab01-shell:
	$(LAB01) exec app bash -il

lab01-clean:
	$(LAB01) down -v --remove-orphans

lab01-fix:
	git apply --check lab01-fd-leak/fix.patch
	git apply lab01-fd-leak/fix.patch

lab01-reset:
	git apply -R --check lab01-fd-leak/fix.patch
	git apply -R lab01-fd-leak/fix.patch

lab02-start:
	$(LAB02) up --build -d

lab02-logs:
	$(LAB02) logs -f --tail=80

lab02-shell:
	$(LAB02) exec app bash -il

lab02-clean:
	$(LAB02) down -v --remove-orphans

lab02-fix:
	git apply --check lab02-blocked-io/fix.patch
	git apply lab02-blocked-io/fix.patch

lab02-reset:
	git apply -R --check lab02-blocked-io/fix.patch
	git apply -R lab02-blocked-io/fix.patch

lab03-start:
	$(LAB03) up --build -d

lab03-logs:
	$(LAB03) logs -f --tail=80

lab03-shell:
	$(LAB03) exec app bash -il

lab03-clean:
	$(LAB03) down -v --remove-orphans

lab03-fix:
	git apply --check lab03-memory-oom/fix.patch
	git apply lab03-memory-oom/fix.patch

lab03-reset:
	git apply -R --check lab03-memory-oom/fix.patch
	git apply -R lab03-memory-oom/fix.patch

lab04-start: lab04-disk

lab04-disk:
	$(LAB04) up -d disk

lab04-inodes:
	$(LAB04) up -d inodes

lab04-deleted-file:
	$(LAB04) up -d deleted-file

lab04-logs:
	$(LAB04) logs -f --tail=80

lab04-shell:
	$(LAB04) exec $(SERVICE) bash -il

lab04-clean:
	$(LAB04) down -v --remove-orphans

lab05-start:
	$(LAB05) up --build -d

lab05-logs:
	$(LAB05) logs -f --tail=80

lab05-shell:
	$(LAB05) exec app bash -il

lab05-db:
	$(LAB05) exec db sh -c 'set -e; mysql -uadmin -plab -e "SELECT id,user,db,command,time,state,info FROM information_schema.processlist WHERE user IN ('\''app'\'','\''admin'\'') ORDER BY id; SHOW STATUS LIKE '\''Threads_connected'\''; SHOW VARIABLES LIKE '\''max_connections'\''; SELECT user,max_user_connections FROM mysql.user WHERE user IN ('\''app'\'','\''admin'\'');"; if ! mysql -uadmin -plab -e "SELECT * FROM performance_schema.data_lock_waits\G"; then echo "performance_schema.data_lock_waits unavailable"; fi; mysql -uadmin -plab -e "SHOW ENGINE INNODB STATUS\G"'

lab05-clean:
	$(LAB05) down -v --remove-orphans

lab05-fix:
	git apply --check lab05-mysql-contention/fix.patch
	git apply lab05-mysql-contention/fix.patch

lab05-reset:
	git apply -R --check lab05-mysql-contention/fix.patch
	git apply -R lab05-mysql-contention/fix.patch

lab06-start:
	$(LAB06) up --build -d

lab06-logs:
	$(LAB06) logs -f --tail=80

lab06-shell:
	$(LAB06) exec client bash -il

lab06-clean:
	$(LAB06) down -v --remove-orphans

lab06-fix:
	git apply --check lab06-retry-storm/fix.patch
	git apply lab06-retry-storm/fix.patch

lab06-reset:
	git apply -R --check lab06-retry-storm/fix.patch
	git apply -R lab06-retry-storm/fix.patch

lab07-start:
	$(LAB07) up -d

lab07-logs:
	$(LAB07) logs -f --tail=80

lab07-shell:
	$(LAB07) exec app bash -il

lab07-clean:
	$(LAB07) down -v --remove-orphans

lab07-fix:
	git apply --check lab07-dns-resolution/fix.patch
	git apply lab07-dns-resolution/fix.patch

lab07-reset:
	git apply -R --check lab07-dns-resolution/fix.patch
	git apply -R lab07-dns-resolution/fix.patch

lab08-start:
	$(LAB08) up -d

lab08-logs:
	$(LAB08) logs -f --tail=80

lab08-shell:
	$(LAB08) exec app bash -il

lab08-clean:
	$(LAB08) down -v --remove-orphans

lab08-fix:
	git apply --check lab08-cpu-throttling/fix.patch
	git apply lab08-cpu-throttling/fix.patch

lab08-reset:
	git apply -R --check lab08-cpu-throttling/fix.patch
	git apply -R lab08-cpu-throttling/fix.patch

lab09-start:
	$(LAB09) up -d

lab09-logs:
	$(LAB09) logs -f --tail=80

lab09-shell:
	$(LAB09) exec client bash -il

lab09-clean:
	$(LAB09) down -v --remove-orphans

lab09-fix:
	git apply --check lab09-tcp-port-exhaustion/fix.patch
	git apply lab09-tcp-port-exhaustion/fix.patch

lab09-reset:
	git apply -R --check lab09-tcp-port-exhaustion/fix.patch
	git apply -R lab09-tcp-port-exhaustion/fix.patch
