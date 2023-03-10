const { SlashCommandBuilder } = require('@discordjs/builders');

module.exports = {
	data: new SlashCommandBuilder()
		.setName('user')
		.setDescription('Replies with user info!'),
	async execute(interaction) {
		await interaction.reply(`Your name: ${interaction.user.username}\nYour tag: ${interaction.user.tag}\nYour id: ${interaction.user.id}`);
	},
};