VERSION=$(jq -r '.version' metadata.json)

test: export RUBYLIB=${PWD}/lib
test:
	@echo "Deleting..."
	@puppet apply tests/delete.pp
	@echo "===> Creating (expect changes)"
	@puppet apply tests/create.pp
	@echo "===> Repeating create (no changes)"
	@puppet apply tests/create.pp
	@echo "===> Updating (expect changes)"
	@puppet apply tests/update.pp
	@echo "===> Repeating update (no changes)"
	@puppet apply tests/update.pp
	@echo "===> Deleting..."
	@puppet apply tests/delete.pp

publish:
	@echo "Publishing version ${VERSION}"
	@git pull || echo "Nothing to pull"
	@(git add . && git commit -m "Publishing ${VERSION}") || echo "Nothing to commit"
	@git push

	@git tag -d ${VERSION} || echo
	@git push origin :refs/tags/${VERSION}

	@git tag -a ${VERSION} -m "Release ${VERSION}"
	@git push origin ${VERSION}

	@puppet module build ${PWD}

