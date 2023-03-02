.SILENT:
help: ## Must be implemented and print a list of all the goals with a sentence.
	sed -n '2p;5p;8p;11p;15p;18p;24p;27p;30p;33p;35p;37p;43p' Makefile | grep "##" | tr -d "##"

lint: ## Checks to see if the code is written in compliance with the linter.
	shellcheck setup.sh

build: ## Compiles the source code of the application to a binary named awesome-api 
	hugo
	go build

run: ## Runs the application in background by executing the binary awesome-api, and write logs into a file named awesome.log.
	chmod u+x awesome-api
	./awesome-api >./awesome.log 2>&1 &

stop: ## Stops the application.
	pgrep awesome-api | xargs kill

clean: ## Delete the binary awesome-api and the log file awesome-api.log.
	rm -rf ./dist
	rm -f awesome-api
	rm -f coverage-integrations.out
	rm -f coverage-units.out

test: ## Tests application's server to ensure that it behaves as expected.
	go test -v -short -coverprofile=coverage-units.out

unit-tests: ## Unit-testing code for the HelloHandler method.
	go test -v -short -coverprofile=coverage-units.out || echo $1

integration-tests: ## Successfully executes a specific Golang integration tests.
	go test -v -coverprofile=coverage-integrations.out || echo $1

check: ## Should succeed by default, and fail when presented with a dead link or a badly written Markdown file.
	
validate: ## Must always succeed by default and should print the result on the stdout
	./w3c_validator.py ./dist/index.html || true
	
post: ## Create a new blog post whose filename and title come from the environment variables
	hugo new posts/$(POST_NAME).md
	sed -i ‘2s/title: .*/title: “$(POST_TITLE)“/’ content/posts/$(POST_NAME).md >/dev/null 2>&1

package: build ## Produces a file awesome-website.zip, containing the binary awesome-api and the directory dist/ directory
	zip -r awesome-website.zip dist awesome-api