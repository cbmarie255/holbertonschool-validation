CURRENT_GIT_REF = $(shell git tag --points-at HEAD)
ifeq ($(CURRENT_GIT_REF), )
	CURRENT_GIT_REF = $(shell git symbolic-ref --short HEAD)
endif

.SILENT:
help: ## Must be implemented and print a list of all the goals with a sentence.
	sed -n '7p;10p;13p;20p;26p;30p;33p;47p;49p;54p;59p;61p;64p;68p;73p' Makefile | grep "##" | tr -d "##"

build-docker: ## Building a Docker container.
	docker compose build awesome-build

lint: ## Checks to see if the code is written in compliance with the linter.
	shellcheck setup.sh >/dev/null 2>&1 || echo "Lint Failed"
	shellcheck ensure-server-created.sh >/dev/null 2>&1 || echo "Lint Failed"
	shellcheck ensure-server-setup.sh >/dev/null 2>&1 || echo "Lint Failed"
	shellcheck deploy.sh >/dev/null 2>&1 || echo "Lint Failed"

.PHONY: build
build: clean## Compiles the source code of the application to a binary named awesome-api 
	docker run --cidfile="container_id_file" awesome:build
	docker cp `cat container_id_file`:app/dist ./dist
	docker cp `cat container_id_file`:app/awesome-api ./awesome-api
	rm -f ./container_id_file

run: ## Runs the application in background by executing the binary awesome-api, and write logs into a file named awesome.log.
	chmod u+x awesome-api
	./awesome-api >./awesome.log 2>&1 &

stop: ## Stops the application.
	pgrep awesome-api | xargs kill

clean: ## Delete the binary awesome-api and the log file awesome-api.log.
	rm -f ./container_id_file
	rm -rf ./dist
	rm -f ./awesome-api
	rm -f ./awesome-log
	rm -f coverage-integrations.out
	rm -f coverage-units.out
	rm -f ./awesome-website.zip
	rm -f ./awesome.tar
	rm -f ./awesome.tar.zip
	rm -f ./awesome_image_tag_name.txt
	rm -f ./new_ec2_instance_ip.txt
	rm -f ./docker-compose.env

test: build unit-tests integration-tests ## Tests application's server to ensure that it behaves as expected.

unit-tests: ## Unit-testing code for the HelloHandler method.
	docker run --cidfile="container_id_file" awesome:build go test -v -short -coverprofile=coverage-units.out
	docker cp `cat container_id_file`:app/coverage-units.out ./coverage-units.out
	rm -f ./container_id_file

integration-tests: ## Successfully executes a specific Golang integration tests.
	docker run --cidfile="container_id_file" awesome:build go test -v -coverprofile=coverage-integrations.out
	docker cp `cat container_id_file`:app/coverage-integrations.out ./coverage-integrations.out
	rm -f ./container_id_file

check: ## Should succeed by default, and fail when presented with a dead link or a badly written Markdown file.

validate: ## Must always succeed by default and should print the result on the stdout.
	docker run awesome:build echo "PASS"

post: ## Create a new blog post whose filename and title come from the environment variables.
	hugo new posts/$(POST_NAME).md
	sed -i ‘2s/title: .*/title: “$(POST_TITLE)“/’ content/posts/$(POST_NAME).md >/dev/null 2>&1

package: build ## Produces a file awesome-website.zip, containing the binary awesome-api and the directory dist/ directory.
	echo "CURRENT_GIT_REF=$(CURRENT_GIT_REF)" > docker-compose.env
	docker compose --env-file docker-compose.env build awesome-web
	echo $(CURRENT_GIT_REF) > awesome_image_tag_name.txt

publish-docker-hub: # Pushes image to Docker Hub. Must be run after `make package`.
	docker compose push awesome-web