documentation:
	nvim --headless -u docgen/minimal_init.vim -c "cd ./docgen" -c "source init.lua" -c 'qa'

local-documentation:
	nvim --headless -c "cd ./docgen" -c "source init.lua" -c 'qa'

format:
	stylua -v --verify .

install_pre_commit:
	cp scripts/pre-commit "$$(git rev-parse --git-dir)/hooks/"

check:
	luacheck lua/
