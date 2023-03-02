CURRENT_GIT_REF = $(shell git tag --points-at HEAD)
ifeq ($(CURRENT_GIT_REF), )
	CURRENT_GIT_REF = $(shell git symbolic-ref --short HEAD)
endif

.SILENT:
help: ## Must be implemented and print a list of all the goals with a sentence.
	sed -n '8p;10p;13p;17p;23p;27p;30p;38p;40p;45p;50p;52p;55p;59p' Makefile | grep "##" | tr -d "##"

build-docker: ## Building a Docker container.
	docker build -f ./build/Dockerfile -t awesome:build .

lint: ## Checks to see if the code is written in compliance with the linter.
	shellcheck setup.sh >/dev/null 2>&1 || echo "Lint Failed"

.PHONY: build
build: clean## Compiles the source code of the application to a binary named awesome-api 
	docker run --cidfile="container_id_file" awesome:build sh -c "hugo; go build"
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
	rm -f awesome-api
	rm -f coverage-integrations.out
	rm -f coverage-units.out
	rm -f ./awesome-website.zip

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
	
validate: ## Must always succeed by default and should print the result on the stdout
	./w3c_validator.py ./dist/index.html || true
	
post: ## Create a new blog post whose filename and title come from the environment variables
	hugo new posts/$(POST_NAME).md
	sed -i ‘2s/title: .*/title: “$(POST_TITLE)“/’ content/posts/$(POST_NAME).md >/dev/null 2>&1

package: build ## Produces a file awesome-website.zip, containing the binary awesome-api and the directory dist/ directory
	docker build -f ./Dockerfile -t awesome:$(CURRENT_GIT_REF) .
	docker save awesome:$(CURRENT_GIT_REF) -o awesome.tar
	zip awesome.tar.zip awesome.tar