.PHONY: lab01-start lab01-logs lab01-shell lab01-clean lab01-fix lab01-reset

LAB01 = docker compose -f lab01-fd-leak/compose.yaml

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
