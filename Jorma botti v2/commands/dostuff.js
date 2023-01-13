const { SlashCommandBuilder } = require('@discordjs/builders');

module.exports = {
	data: new SlashCommandBuilder()
		.setName('dostuff')
		.setDescription('Does stuff'),
	async execute(interaction) {
		await interaction.reply('no');
	},
};