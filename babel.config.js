module.exports = {
	presets: [
		'@vue/app',
		'@babel/env',
		'@vue/babel-preset-app',
		[
			'es2015', { modules: false }
		]
	],
	plugins: [
		[
			'component',
			{
				libraryName: 'element-ui',
				styleLibraryName: 'theme-default'
			}
		]
	]
}
