const { SlashCommandBuilder } = require('@discordjs/builders');

module.exports = {
	data: new SlashCommandBuilder()
		.setName('commands')
		.setDescription('Lists all commands'),
	async execute(interaction) {
		await interaction.reply('commands: lists all commands.\ndostuff: does stuff.\nping: replies with pong.\necho: replies with whatever you say.\nserver: gives some information about the server.\nuser: gives some information about the user.\nminesweeper: its minesweeper.');
	},
};