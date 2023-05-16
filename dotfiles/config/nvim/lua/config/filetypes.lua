vim.filetype.add({
	extension = {
		eslintrc = "jsonc",
		mdx = "markdown",
		prettierrc = "json",
	},
	filename = {
		[".eslintrc.json"] = "jsonc",
	},
	pattern = {
		[".*%.env.*"] = "sh",
		["tsconfig.*.json"] = "jsonc",
	},
})
