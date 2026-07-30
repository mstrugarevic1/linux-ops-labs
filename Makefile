.PHONY: lab01-start lab01-logs lab01-shell lab01-clean lab01-fix lab01-reset \
	lab02-start lab02-logs lab02-shell lab02-clean lab02-fix lab02-reset \
	lab03-start lab03-logs lab03-shell lab03-clean lab03-fix lab03-reset \
	lab04-start lab04-logs lab04-shell lab04-clean \
	lab05-start lab05-logs lab05-shell lab05-db lab05-clean lab05-fix lab05-reset \
	lab06-start lab06-logs lab06-shell lab06-clean lab06-fix lab06-reset

LAB01 = docker compose -f lab01-fd-leak/compose.yaml
LAB02 = docker compose -f lab02-blocked-io/compose.yaml
LAB03 = docker compose -f lab03-memory-oom/compose.yaml
LAB04 = docker compose -f lab04-disk-inodes/compose.yaml
LAB05 = docker compose -f lab05-mysql-contention/compose.yaml
LAB06 = docker compose -f lab06-retry-storm/compose.yaml

lab01-start:
	$(LAB01) up --build -d

lab01-logs:
	$(LAB01) logs -f --tail=80

lab01-shell:
	$(LAB01) exec app sh

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
	$(LAB02) exec app sh

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
	$(LAB03) exec app sh

lab03-clean:
	$(LAB03) down -v --remove-orphans

lab03-fix:
	git apply --check lab03-memory-oom/fix.patch
	git apply lab03-memory-oom/fix.patch

lab03-reset:
	git apply -R --check lab03-memory-oom/fix.patch
	git apply -R lab03-memory-oom/fix.patch

lab04-start:
	$(LAB04) up -d

lab04-logs:
	$(LAB04) logs -f --tail=80

lab04-shell:
	$(LAB04) exec app sh

lab04-clean:
	$(LAB04) down -v --remove-orphans

lab05-start:
	$(LAB05) up --build -d

lab05-logs:
	$(LAB05) logs -f --tail=80

lab05-shell:
	$(LAB05) exec app sh

lab05-db:
	$(LAB05) exec db mysql -uadmin -plab -e "SHOW PROCESSLIST; SHOW ENGINE INNODB STATUS\G"

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
	$(LAB06) exec client sh

lab06-clean:
	$(LAB06) down -v --remove-orphans

lab06-fix:
	git apply --check lab06-retry-storm/fix.patch
	git apply lab06-retry-storm/fix.patch

lab06-reset:
	git apply -R --check lab06-retry-storm/fix.patch
	git apply -R lab06-retry-storm/fix.patch
